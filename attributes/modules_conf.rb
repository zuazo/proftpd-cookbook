# encoding: UTF-8
#
# Cookbook Name:: onddo_proftpd
# Attributes:: modules_conf
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
when 'redhat', 'centos', 'scientific', 'fedora', 'suse', 'amazon'
  default['proftpd']['conf']['if_module']['dso']['module_path'] =
    '/usr/libexec/proftpd'
# when 'debian', 'ubuntu' then
else
  default['proftpd']['conf']['if_module']['dso']['module_path'] =
    '/usr/lib/proftpd'
end

default['proftpd']['conf']['if_module']['dso']['module_controls_acls'] = [
  'insmod,rmmod allow user root',
  'lsmod allow user *'
]

# we need to use an array to preserver the order
default['proftpd']['conf']['if_module']['dso']['load_module'] = %w(
  dso ctrls_admin tls radius quotatab quotatab_file
  quotatab_radius wrap rewrite load ban wrap2
  wrap2_file ratio site_misc
  facl ifsession
)

default['proftpd']['conf']['if_module']['ctrls_admin']['prefix'] =
  'AdminControls'
default['proftpd']['conf']['if_module']['ctrls_admin']['engine'] = false

default['proftpd']['conf']['if_module']['ctrls']['prefix'] = 'Controls'
default['proftpd']['conf']['if_module']['ctrls']['engine'] = false
default['proftpd']['conf']['if_module']['ctrls']['max_clients'] = 2
default['proftpd']['conf']['if_module']['ctrls']['log'] =
  '/var/log/proftpd/controls.log'
default['proftpd']['conf']['if_module']['ctrls']['interval'] = 5
default['proftpd']['conf']['if_module']['ctrls']['socket'] =
  '/var/run/proftpd/proftpd.sock'

# Delay engine reduces impact of the so-called Timing Attack described in
# http://www.securityfocus.com/bid/11430/discuss
# It is on by default.
default['proftpd']['conf']['if_module']['delay']['prefix'] = 'Delay'
default['proftpd']['conf']['if_module']['delay']['engine'] = true

# This is useful for masquerading address with dynamic IPs:
# refresh any configured MasqueradeAddress directives every 8 hours
# default['proftpd']['conf']['if_module']['delay']['dyn_masq_refresh'] = 28800

# This is used for ordinary LDAP connections, with or without TLS
default['proftpd']['conf']['if_module']['ldap']['prefix'] = 'LDAP'
# default['proftpd']['conf']['if_module']['ldap']['server'] =
#   'ldap://ldap.example.com'
# default['proftpd']['conf']['if_module']['ldap']['bind_dn'] =
#   '"cn=admin,dc=example,dc=com" "admin_password"'
# default['proftpd']['conf']['if_module']['ldap']['users'] =
#   'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# To be set on only for LDAP/TLS on ordinary port, for LDAP+SSL see below
# default['proftpd']['conf']['if_module']['ldap']['use_tls'] = true

# This is used for encrypted LDAPS connections
# default['proftpd']['conf']['if_module']['ldap']['server'] =
#   'ldaps://ldap.example.com'
# default['proftpd']['conf']['if_module']['ldap']['bind_dn'] =
#   '"cn=admin,dc=example,dc=com" "admin_password"'
# default['proftpd']['conf']['if_module']['ldap']['users'] =
#   'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

default['proftpd']['conf']['if_module']['quotatab']['quota_engine'] = false

default['proftpd']['conf']['if_module']['ratio']['ratios'] = false

# Choose a SQL backend among MySQL or PostgreSQL.
# Both modules are loaded in default configuration, so you have to specify the
# backend or comment out the unused module in /etc/proftpd/modules.conf.
# Use 'mysql' or 'postgres' as possible values.
default['proftpd']['conf']['if_module']['sql']['prefix'] = 'SQL'
# default['proftpd']['conf']['if_module']['sql']['backend'] = 'mysql'

# default['proftpd']['conf']['if_module']['sql']['engine'] = true
# default['proftpd']['conf']['if_module']['sql']['authenticate'] = true

# Use both a crypted or plaintext password
# default['proftpd']['conf']['if_module']['sql']['auth_types'] =
#   'Crypt Plaintext'

# Use a backend-crypted or a crypted password
# default['proftpd']['conf']['if_module']['sql']['auth_types'] = 'Backend Crypt'

# Connection
# default['proftpd']['conf']['if_module']['sql']['connect_info'] =
#   'proftpd@sql.example.com proftpd_user proftpd_password'

# Describes both users/groups tables
# default['proftpd']['conf']['if_module']['sql']['user_info'] =
#   'users userid passwd uid gid homedir shell'
# default['proftpd']['conf']['if_module']['sql']['group_info'] =
#   'groups groupname gid members'

default['proftpd']['conf']['if_module']['tls']['prefix'] = 'TLS'
# default['proftpd']['conf']['if_module']['tls']['engine'] = true
# default['proftpd']['conf']['if_module']['tls']['log'] =
#   '/var/log/proftpd/tls.log'
# default['proftpd']['conf']['if_module']['tls']['protocol'] = 'SSLv23'

# Server SSL certificate. You can generate a self-signed certificate using
# a command like:
#
# openssl req -x509 -newkey rsa:1024 \
#          -keyout /etc/ssl/private/proftpd.key \
#          -out /etc/ssl/certs/proftpd.crt \
#          -nodes -days 365
#
# The proftpd.key file must be readable by root only. The other file can be
# readable by anyone.
#
# chmod 0600 /etc/ssl/private/proftpd.key
# chmod 0640 /etc/ssl/private/proftpd.key
#
# default['proftpd']['conf']['if_module']['tls']['RSA_certificate_file'] =
#   '/etc/ssl/certs/proftpd.crt'
# default['proftpd']['conf']['if_module']['tls']['RSA_certificate_key_file'] =
#   '/etc/ssl/private/proftpd.key'

# CA the server trusts...
# default['proftpd']['conf']['if_module']['tls']['CA_certificate_file'] =
#   '/etc/ssl/certs/CA.pem'
# ...or avoid CA cert and be verbose
# default['proftpd']['conf']['if_module']['tls']['options'] =
#   'NoCertRequest EnableDiags'
# ... or the same with relaxed session use for some clients (e.g. FireFtp)
# default['proftpd']['conf']['if_module']['tls']['options'] =
#   'NoCertRequest EnableDiags NoSessionReuseRequired'

# Per default drop connection if client tries to start a renegotiate
# This is a fix for CVE-2009-3555 but could break some clients.
# default['proftpd']['conf']['if_module']['tls']['options'] =
#   'AllowClientRenegotiations'

# Authenticate clients that want to use FTP over TLS?
# default['proftpd']['conf']['if_module']['tls']['verify_client'] = false

# Are clients required to use FTP over TLS when talking to this server?
# default['proftpd']['conf']['if_module']['tls']['required'] = true

# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
# default['proftpd']['conf']['if_module']['tls']['renegotiate'] = 'required off'

# default['proftpd']['conf']['if_module']['vroot']['vroot_engine'] = true
# default['proftpd']['conf']['if_module']['vroot']['vroot_alias'] =
#   '/var/ftp/upload upload'
# vhost = default['proftpd']['conf']['if_module']['vroot']['virtual_host']
# vhost['127.0.0.1'] = (
#   'vroot_engine' => true,
#   'vroot_server_root' => '/tmp',
#   'vroot_options' => 'allowSymlinks',
#   'default_root' => '~',
# )
