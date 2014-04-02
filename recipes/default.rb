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

if platform?('redhat', 'centos', 'amazon')
  include_recipe 'yum-epel'
end

# Bugfix: relocation error: proftpd: symbol SSLeay_version, version OPENSSL_1.0.1 not defined in file libcrypto.so.10 with link time reference
if platform?('fedora')
  package 'openssl' do
    action :upgrade
    not_if "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' | cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
  end
end

#
# Install required packages
#

package 'proftpd' do
  notifies :reload, 'ohai[reload_proftpd]', :immediately
end

if node['proftpd']['conf']['if_module']['dso']['load_module'].include?('dso')
  node['proftpd']['conf']['if_module']['dso']['load_module'].uniq.each do |mod|
    packages = node['proftpd']['module_packages'][mod]
    if packages.kind_of?(Array)
      packages.each do |pkg|
        package pkg do
          notifies :reload, 'service[proftpd]'
        end # package
      end # package.each
    end # if packages.kind_of?(Array)
  end # ['dso']['load_module'].each
end # include?('dso')

# Create the required directories

directory '/etc/proftpd'

node['proftpd']['conf']['include'].each do |dir|
  directory dir
end

#
# Create configuration files
#

template '/etc/proftpd/proftpd.conf' do
  variables(
    :compiled_in_modules => node['proftpd']['compiled_in_modules'],
    :conf => node['proftpd']['conf']
  )
  notifies :restart, 'service[proftpd]'
end

link '/etc/proftpd.conf' do
  to '/etc/proftpd/proftpd.conf'
end

service 'proftpd' do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end
