# encoding: UTF-8
#
# Cookbook Name:: onddo_proftpd
# Attributes:: module_packages
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
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

case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['proftpd']['module_packages']['ldap'] = %w{proftpd-ldap}
  default['proftpd']['module_packages']['sql_mysql'] = %w{proftpd-mysql}
  default['proftpd']['module_packages']['sql_postgres'] = %w{proftpd-postgresql}
# when 'debian', 'ubuntu' then
else
  default['proftpd']['module_packages']['autohost'] = %w{proftpd-mod-autohost}
  default['proftpd']['module_packages']['case'] = %w{proftpd-mod-case}
  default['proftpd']['module_packages']['clamav'] = %w{proftpd-mod-clamav}
  default['proftpd']['module_packages']['dnsbl'] = %w{proftpd-mod-dnsbl}
  default['proftpd']['module_packages']['fsync'] = %w{proftpd-mod-fsync}
  default['proftpd']['module_packages']['geoip'] = %w{proftpd-mod-geoip}
  default['proftpd']['module_packages']['ldap'] = %w{proftpd-mod-ldap}
  default['proftpd']['module_packages']['msg'] = %w{proftpd-mod-msg}
  default['proftpd']['module_packages']['sql_mysql'] = %w{proftpd-mod-mysql}
  default['proftpd']['module_packages']['sql_odbc'] = %w{proftpd-mod-odbc}
  default['proftpd']['module_packages']['sql_postgres'] = %w{proftpd-mod-pgsql}
  default['proftpd']['module_packages']['sql_sqlite'] = %w{proftpd-mod-sqlite}
  default['proftpd']['module_packages']['tar'] = %w{proftpd-mod-tar}
  default['proftpd']['module_packages']['vroot'] = %w{proftpd-mod-vroot}
end
