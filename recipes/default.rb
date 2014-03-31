#
# Cookbook Name:: onddo_proftpd
# Recipe:: default
#
# Copyright 2013, Onddo Labs, Sl.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'onddo_proftpd::ohai_plugin'

if platform?('redhat', 'centos', 'fedora', 'amazon')
  include_recipe 'yum-epel'
end

package 'proftpd' do
  notifies :reload, 'ohai[reload_proftpd]', :immediately
end

directory '/etc/proftpd'
node['onddo_proftpd']['conf_included_dirs'].each do |dir|
  directory "/etc/proftpd/#{dir}"
end

node['onddo_proftpd']['loaded_modules'].each do |mod|
  path = "/etc/proftpd/modules/#{mod}.conf"
  conf = node['onddo_proftpd']['modules'][mod]
  if conf.kind_of?(Hash) and
    conf = conf.to_hash
    packages = conf.delete('packages')
    prefix = conf.delete('prefix')

    # Install module
    if packages.kind_of?(Array)
      packages.each do |pkg|
        package pkg do
          notifies :reload, 'service[proftpd]'
        end
      end
    end

    # Configure module
    template path do
      source 'module.conf.erb'
      variables(
        :name => mod,
        :conf => conf,
        :prefix => prefix
      )
      not_if do conf.empty? end
      notifies :reload, 'service[proftpd]'
    end
  end
end

template '/etc/proftpd/modules.conf' do
  variables(
    :module_path => node['onddo_proftpd']['module_path'],
    :control_acls => node['onddo_proftpd']['module_controls_acls'],
    :loaded_modules => node['onddo_proftpd']['loaded_modules']
  )
  notifies :reload, 'service[proftpd]'
end

%w{global directories virtuals anonymous limits proftpd}.each do |conf|
  template "/etc/proftpd/#{conf}.conf" do
    variables(
      :conf => node['onddo_proftpd'],
      :included_dirs => node['onddo_proftpd']['conf_included_dirs']
    )
    notifies :reload, 'service[proftpd]'
  end
end

link '/etc/proftpd.conf' do
  to '/etc/proftpd/proftpd.conf'
end

service 'proftpd' do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end
