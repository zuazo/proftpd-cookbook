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

%w{virtuals modules}.each do |dir|
  directory "/etc/proftpd/#{dir}"
end

service 'proftpd' do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end

node['onddo_proftpd']['loaded_modules'].each do |mod|
  path = "/etc/proftpd/modules/#{mod}.conf"
  if node['onddo_proftpd']['modules'][mod].kind_of?(Hash) and
    # Install module
    if node['onddo_proftpd']['modules'][mod]['packages'].kind_of?(Array)
      node['onddo_proftpd']['modules'][mod]['packages'].each do |pkg|
        package pkg do
          notifies :reload, 'service[proftpd]'
        end
      end
    end
    # Configure module
    if node['onddo_proftpd']['modules'][mod]['conf'].kind_of?(Hash) and
      not node['onddo_proftpd']['modules'][mod]['conf'].empty?
      template path do
        source 'module.conf.erb'
        variables(
          :conf => node['onddo_proftpd']['modules'][mod]['conf']
        )
        notifies :reload, 'service[proftpd]'
      end
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

template '/etc/proftpd/proftpd.conf' do
  variables(
    :conf => node['onddo_proftpd']['conf']
  )
  notifies :reload, 'service[proftpd]'
end

link '/etc/proftpd.conf' do
  to '/etc/proftpd/proftpd.conf'
end
