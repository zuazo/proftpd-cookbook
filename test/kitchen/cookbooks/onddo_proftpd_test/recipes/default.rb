#
# Cookbook Name:: onddo_proftpd_test
# Recipe:: default
#
# Copyright 2014, Onddo Labs, Sl.
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

# dummy user for tests
user 'user1' do
  # password 'user1'
  password '$6$5naWIHNh$txoUAK0hpCcYvAQv0oi9klC5uvCwwmJatbvPH6.SBOyAlspBlgssw0BZNZRQch/G.Ad60QEFX4OCGNOu2xEqs.'
  supports :manage_home => true
end
group 'user1' do
  members [ 'user1' ]
end
# :manage_home does not work?
directory '/home/user1' do
  user 'user1'
  group 'user1'
end

node.default['proftpd']['conf']['default_address'] = node['ipaddress']

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
node.default['proftpd']['conf']['passive_ports'] = '49152 65534'

# Logging onto /var/log/lastlog is enabled but set to off by default
# node.default['proftpd']['conf']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
node.default['proftpd']['conf']['set_env']['TZ'] = ':/etc/localtime'

node.default['proftpd']['conf']['virtual_host']['ftp.server.com'] = {
  'server_admin' => 'ftpmaster@server.com',
  'server_name' => 'Big FTP Archive',
  'transfer_log' => '/var/log/proftpd/xfer-ftp.server.com.log',
  'max_login_attempts' => 3,
  'require_valid_shell' => false,
  'default_root' => '/tmp',
  'allow_overwrite' => true,
}

user 'ftp' do
  system true
  supports :manage_home => true
end
node.default['proftpd']['conf']['anonymous']['~ftp'] = {
  'user' => 'ftp',
  'group' => 'nogroup',
  'user_alias' => 'anonymous ftp',
  'dir_fake_user' => 'on ftp',
  'dir_fake_group' => 'on ftp',
  'require_valid_shell' => false,
  'max_clients' => 10,
  'display_login' => 'welcome.msg',
  'display_chdir' => '.message',
  'directory' => {
    '*' => {
      'limit' => {
        'write' => {
          'deny_all' => nil,
        },
      },
    },
    'incoming' => {
      'umask' => '022 022',
      'limit' => {
        'read write' => {
          'deny_all' => nil,
        },
        'stor' => {
          'allow_all' => nil,
        },
      },
    },
  },
}

# This is used for ordinary LDAP connections, with or without TLS
# node.default['proftpd']['conf']['if_module']['ldap']['server'] = 'ldap://ldap.example.com'
# node.default['proftpd']['conf']['if_module']['ldap']['bind_dn'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# node.default['proftpd']['conf']['if_module']['ldap']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# To be set on only for LDAP/TLS on ordinary port, for LDAP+SSL see below
# node.default['proftpd']['conf']['if_module']['ldap']['use_tls'] = true

# This is used for encrypted LDAPS connections
# node.default['proftpd']['conf']['if_module']['ldap']['server'] = 'ldaps://ldap.example.com'
# node.default['proftpd']['conf']['if_module']['ldap']['bind_dn'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# node.default['proftpd']['conf']['if_module']['ldap']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# Choose a SQL backend among MySQL or PostgreSQL.
# Both modules are loaded in default configuration, so you have to specify the backend
# or comment out the unused module in /etc/proftpd/modules.conf.
# Use 'mysql' or 'postgres' as possible values.
# node.default['proftpd']['conf']['if_module']['sql']['prefix'] = 'SQL'
# node.default['proftpd']['conf']['if_module']['sql']['backend'] = 'mysql'

# node.default['proftpd']['conf']['if_module']['sql']['engine'] = true
# node.default['proftpd']['conf']['if_module']['sql']['authenticate'] = true

# Use both a crypted or plaintext password
# node.default['proftpd']['conf']['if_module']['sql']['auth_types'] = 'Crypt Plaintext'

# Connection
# node.default['proftpd']['conf']['if_module']['sql']['connect_info'] = 'proftpd@sql.example.com proftpd_user proftpd_password'

# Describes both users/groups tables
# node.default['proftpd']['conf']['if_module']['sql']['user_info'] = 'users userid passwd uid gid homedir shell'
# node.default['proftpd']['conf']['if_module']['sql']['group_info'] = 'groups groupname gid members'

# TLS configuration
cert = ssl_certificate 'proftpd'
node.default['proftpd']['conf']['if_module']['tls']['prefix'] = 'TLS'
node.default['proftpd']['conf']['if_module']['tls']['engine'] = true
node.default['proftpd']['conf']['if_module']['tls']['log'] = '/var/log/proftpd/tls.log'
# Support both SSLv3 and TLSv1
node.default['proftpd']['conf']['if_module']['tls']['protocol'] = 'SSLv3 TLSv1'
# Are clients required to use FTP over TLS when talking to this server?
node.default['proftpd']['conf']['if_module']['tls']['required'] = false
node.default['proftpd']['conf']['if_module']['tls']['rsa_certificate_file'] = cert.cert_path
node.default['proftpd']['conf']['if_module']['tls']['rsa_certificate_key_file'] = cert.key_path
# Authenticate clients that want to use FTP over TLS?
node.default['proftpd']['conf']['if_module']['tls']['verify_client'] = false
# Avoid CA cert with relaxed session use for some clients (e.g. FireFtp)
node.default['proftpd']['conf']['if_module']['tls']['options'] = 'NoCertRequest EnableDiags NoSessionReuseRequired'
# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
node.default['proftpd']['conf']['if_module']['tls']['renegotiate'] = 'none'

# Server SSL certificate. You can generate a self-signed certificate using
# a command like:
#
# openssl req -x509 -newkey rsa:1024 \
#          -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt \
#          -nodes -days 365
#
# The proftpd.key file must be readable by root only. The other file can be
# readable by anyone.
#
# chmod 0600 /etc/ssl/private/proftpd.key
# chmod 0640 /etc/ssl/private/proftpd.key
#
# node.default['proftpd']['conf']['if_module']['tls']['RSA_certificate_file'] = '/etc/ssl/certs/proftpd.crt'
# node.default['proftpd']['conf']['if_module']['tls']['RSA_certificate_key_file'] = '/etc/ssl/private/proftpd.key'

# CA the server trusts...
# node.default['proftpd']['conf']['if_module']['tls']['CA_certificate_file'] = '/etc/ssl/certs/CA.pem'
# ...or avoid CA cert and be verbose
# node.default['proftpd']['conf']['if_module']['tls']['options'] = 'NoCertRequest EnableDiags'
# ... or the same with relaxed session use for some clients (e.g. FireFtp)
# node.default['proftpd']['conf']['if_module']['tls']['options'] = 'NoCertRequest EnableDiags NoSessionReuseRequired'

# Per default drop connection if client tries to start a renegotiate
# This is a fix for CVE-2009-3555 but could break some clients.
# node.default['proftpd']['conf']['if_module']['tls']['options'] = 'AllowClientRenegotiations'

# Authenticate clients that want to use FTP over TLS?
# node.default['proftpd']['conf']['if_module']['tls']['verify_client'] = false

# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
# node.default['proftpd']['conf']['if_module']['tls']['renegotiate'] = 'required off'

node.default['proftpd']['conf']['if_module']['vroot']['vroot_engine'] = true
node.default['proftpd']['conf']['if_module']['vroot']['vroot_alias'] = '/var/ftp/upload upload'
node.default['proftpd']['conf']['if_module']['vroot']['virtual_host']['127.0.0.1'] = {
  'vroot_engine' => true,
  'vroot_server_root' => '/tmp',
  'vroot_options' => 'allowSymlinks',
  'default_root' => '~',
}

# we need to use an array to preserver the order
node.default['proftpd']['loaded_modules'] = %w{
  dso ctrls_admin tls radius quotatab quotatab_file
  quotatab_radius wrap rewrite load ban wrap2
  wrap2_file exec shaper ratio site_misc sftp
  vroot
  sftp_pam facl ifsession
}

include_recipe 'onddo_proftpd'
