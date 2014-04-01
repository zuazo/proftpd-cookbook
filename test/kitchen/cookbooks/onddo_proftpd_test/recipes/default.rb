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

node.default['onddo_proftpd']['default_address'] = node['ipaddress']

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
node.default['onddo_proftpd']['passive_ports'] = '49152 65534'

# Logging onto /var/log/lastlog is enabled but set to off by default
# node.default['onddo_proftpd']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
node.default['onddo_proftpd']['set_env']['TZ'] = ':/etc/localtime'

node.default['onddo_proftpd']['virtual_host']['ftp.server.com'] = {
  'server_admin' => 'ftpmaster@server.com',
  'server_name' => 'Big FTP Archive',
  'transfer_log' => '/var/log/proftpd/xfer/ftp.server.com',
  'max_login_attempts' => 3,
  'require_valid_shell' => false,
  'default_root' => '/srv/ftp_root',
  'allow_overwrite' => true,
}

user 'ftp' do
  system true
end
node.default['onddo_proftpd']['anonymous']['~ftp'] = {
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
# node.default['onddo_proftpd']['modules']['ldap']['server'] = 'ldap://ldap.example.com'
# node.default['onddo_proftpd']['modules']['ldap']['bind_dn'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# node.default['onddo_proftpd']['modules']['ldap']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# To be set on only for LDAP/TLS on ordinary port, for LDAP+SSL see below
# node.default['onddo_proftpd']['modules']['ldap']['use_tls'] = true

# This is used for encrypted LDAPS connections
# node.default['onddo_proftpd']['modules']['ldap']['server'] = 'ldaps://ldap.example.com'
# node.default['onddo_proftpd']['modules']['ldap']['bind_dn'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# node.default['onddo_proftpd']['modules']['ldap']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# Choose a SQL backend among MySQL or PostgreSQL.
# Both modules are loaded in default configuration, so you have to specify the backend
# or comment out the unused module in /etc/proftpd/modules.conf.
# Use 'mysql' or 'postgres' as possible values.
# node.default['onddo_proftpd']['modules']['sql']['prefix'] = 'SQL'
# node.default['onddo_proftpd']['modules']['sql']['backend'] = 'mysql'

# node.default['onddo_proftpd']['modules']['sql']['engine'] = true
# node.default['onddo_proftpd']['modules']['sql']['authenticate'] = true

# Use both a crypted or plaintext password
# node.default['onddo_proftpd']['modules']['sql']['auth_types'] = %w{Crypt Plaintext}

# Connection
# node.default['onddo_proftpd']['modules']['sql']['connect_info'] = 'proftpd@sql.example.com proftpd_user proftpd_password'

# Describes both users/groups tables
# node.default['onddo_proftpd']['modules']['sql']['user_info'] = %w{users userid passwd uid gid homedir shell}
# node.default['onddo_proftpd']['modules']['sql']['group_info'] = %w{groups groupname gid members}

# TLS configuration
cert = ssl_certificate 'proftpd'
node.default['onddo_proftpd']['modules']['tls']['prefix'] = 'TLS'
node.default['onddo_proftpd']['modules']['tls']['engine'] = true
node.default['onddo_proftpd']['modules']['tls']['log'] = '/var/log/proftpd/tls.log'
# Support both SSLv3 and TLSv1
node.default['onddo_proftpd']['modules']['tls']['protocol'] = %w{SSLv3 TLSv1}
# Are clients required to use FTP over TLS when talking to this server?
node.default['onddo_proftpd']['modules']['tls']['required'] = false
node.default['onddo_proftpd']['modules']['tls']['rsa_certificate_file'] = cert.cert_path
node.default['onddo_proftpd']['modules']['tls']['rsa_certificate_key_file'] = cert.key_path
# Authenticate clients that want to use FTP over TLS?
node.default['onddo_proftpd']['modules']['tls']['verify_client'] = false
# Avoid CA cert with relaxed session use for some clients (e.g. FireFtp)
node.default['onddo_proftpd']['modules']['tls']['options'] = %w{NoCertRequest EnableDiags NoSessionReuseRequired}
# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
node.default['onddo_proftpd']['modules']['tls']['renegotiate'] = 'none'

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
# node.default['onddo_proftpd']['modules']['tls']['RSA_certificate_file'] = '/etc/ssl/certs/proftpd.crt'
# node.default['onddo_proftpd']['modules']['tls']['RSA_certificate_key_file'] = '/etc/ssl/private/proftpd.key'

# CA the server trusts...
# node.default['onddo_proftpd']['modules']['tls']['CA_certificate_file'] = '/etc/ssl/certs/CA.pem'
# ...or avoid CA cert and be verbose
# node.default['onddo_proftpd']['modules']['tls']['options'] = %w{NoCertRequest EnableDiags}
# ... or the same with relaxed session use for some clients (e.g. FireFtp)
# node.default['onddo_proftpd']['modules']['tls']['options'] = %w{NoCertRequest EnableDiags NoSessionReuseRequired}

# Per default drop connection if client tries to start a renegotiate
# This is a fix for CVE-2009-3555 but could break some clients.
# node.default['onddo_proftpd']['modules']['tls']['options'] = %w{AllowClientRenegotiations}

# Authenticate clients that want to use FTP over TLS?
# node.default['onddo_proftpd']['modules']['tls']['verify_client'] = false

# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
# node.default['onddo_proftpd']['modules']['tls']['renegotiate'] = 'required off'

node.default['onddo_proftpd']['modules']['vroot']['vroot_engine'] = true
node.default['onddo_proftpd']['modules']['vroot']['vroot_alias'] = '/var/ftp/upload upload'
node.default['onddo_proftpd']['modules']['vroot']['virtual_host']['127.0.0.1'] = {
  'vroot_engine' => true,
  'vroot_server_root' => '/tmp',
  'vroot_options' => %w{allowSymlinks},
  'default_root' => '~',
}

# we need to use an array to preserver the order
node.default['onddo_proftpd']['loaded_modules'] = %w{
  ctrls_admin tls radius quotatab quotatab_file
  quotatab_radius wrap rewrite load ban wrap2
  wrap2_file exec shaper ratio site_misc sftp
  vroot
  sftp_pam facl ifsession
}

include_recipe 'onddo_proftpd'
