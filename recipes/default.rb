#
# Cookbook Name:: onddo-proftpd
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

include_recipe 'onddo-proftpd::ohai_plugin'

if platform?('redhat', 'centos', 'fedora', 'amazon')
  include_recipe 'yum-epel'
end

package 'proftpd' do
  notifies :reload, 'ohai[reload_proftpd]', :immediately
end

service 'proftpd' do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end

template '/etc/proftpd/proftpd.conf' do
  variables(
    :conf => node['onddo-proftpd']['conf']
  )
  notifies :reload, 'service[proftpd]'
end
