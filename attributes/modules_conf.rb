default['onddo_proftpd']['modules']['ctrls_admin']['prefix'] = 'AdminControls'
default['onddo_proftpd']['modules']['ctrls_admin']['engine'] = false

default['onddo_proftpd']['modules']['ctrls']['prefix'] = 'Controls'
default['onddo_proftpd']['modules']['ctrls']['controls_engine'] = false
default['onddo_proftpd']['modules']['ctrls']['controls_max_clients'] = 2
default['onddo_proftpd']['modules']['ctrls']['controls_log'] = '/var/log/proftpd/controls.log'
default['onddo_proftpd']['modules']['ctrls']['controls_interval'] = 5
default['onddo_proftpd']['modules']['ctrls']['controls_socket'] = '/var/run/proftpd/proftpd.sock'

# Delay engine reduces impact of the so-called Timing Attack described in
# http://www.securityfocus.com/bid/11430/discuss
# It is on by default.
default['onddo_proftpd']['modules']['delay']['prefix'] = 'Delay'
default['onddo_proftpd']['modules']['delay']['delay_engine'] = true

# This is useful for masquerading address with dynamic IPs:
# refresh any configured MasqueradeAddress directives every 8 hours
# default['onddo_proftpd']['modules']['delay']['dyn_masq_refresh'] = 28800

# This is used for ordinary LDAP connections, with or without TLS
default['onddo_proftpd']['modules']['ldap']['prefix'] = 'LDAP'
# default['onddo_proftpd']['modules']['ldap']['server'] = 'ldap://ldap.example.com'
# default['onddo_proftpd']['modules']['ldap']['bind_dn'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# default['onddo_proftpd']['modules']['ldap']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# To be set on only for LDAP/TLS on ordinary port, for LDAP+SSL see below
# default['onddo_proftpd']['modules']['ldap']['use_tls'] = true

# This is used for encrypted LDAPS connections
# default['onddo_proftpd']['modules']['ldap']['server'] = 'ldaps://ldap.example.com'
# default['onddo_proftpd']['modules']['ldap']['bind_dn'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# default['onddo_proftpd']['modules']['ldap']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

default['onddo_proftpd']['modules']['quotatab']['quota_engine'] = false

default['onddo_proftpd']['modules']['ratio']['ratios'] = false

# Choose a SQL backend among MySQL or PostgreSQL.
# Both modules are loaded in default configuration, so you have to specify the backend
# or comment out the unused module in /etc/proftpd/modules.conf.
# Use 'mysql' or 'postgres' as possible values.
default['onddo_proftpd']['modules']['sql']['prefix'] = 'SQL'
# default['onddo_proftpd']['modules']['sql']['backend'] = 'mysql'

# default['onddo_proftpd']['modules']['sql']['engine'] = true
# default['onddo_proftpd']['modules']['sql']['authenticate'] = true

# Use both a crypted or plaintext password
# default['onddo_proftpd']['modules']['sql']['auth_types'] = %w{Crypt Plaintext}

# Use a backend-crypted or a crypted password
# default['onddo_proftpd']['modules']['sql']['auth_types'] = %w{Backend Crypt}

# Connection
# default['onddo_proftpd']['modules']['sql']['connect_info'] = 'proftpd@sql.example.com proftpd_user proftpd_password'

# Describes both users/groups tables
# default['onddo_proftpd']['modules']['sql']['user_info'] = %w{users userid passwd uid gid homedir shell}
# default['onddo_proftpd']['modules']['sql']['group_info'] = %w{groups groupname gid members}

default['onddo_proftpd']['modules']['tls']['prefix'] = 'TLS'
# default['onddo_proftpd']['modules']['tls']['engine'] = true
# default['onddo_proftpd']['modules']['tls']['log'] = '/var/log/proftpd/tls.log'
# default['onddo_proftpd']['modules']['tls']['protocol'] = 'SSLv23'

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
# default['onddo_proftpd']['modules']['tls']['RSA_certificate_file'] = '/etc/ssl/certs/proftpd.crt'
# default['onddo_proftpd']['modules']['tls']['RSA_certificate_key_file'] = '/etc/ssl/private/proftpd.key'

# CA the server trusts...
# default['onddo_proftpd']['modules']['tls']['CA_certificate_file'] = '/etc/ssl/certs/CA.pem'
# ...or avoid CA cert and be verbose
# default['onddo_proftpd']['modules']['tls']['options'] = %w{NoCertRequest EnableDiags}
# ... or the same with relaxed session use for some clients (e.g. FireFtp)
# default['onddo_proftpd']['modules']['tls']['options'] = %w{NoCertRequest EnableDiags NoSessionReuseRequired}

# Per default drop connection if client tries to start a renegotiate
# This is a fix for CVE-2009-3555 but could break some clients.
# default['onddo_proftpd']['modules']['tls']['options'] = %w{AllowClientRenegotiations}

# Authenticate clients that want to use FTP over TLS?
# default['onddo_proftpd']['modules']['tls']['verify_client'] = false

# Are clients required to use FTP over TLS when talking to this server?
# default['onddo_proftpd']['modules']['tls']['required'] = true

# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
# default['onddo_proftpd']['modules']['tls']['renegotiate'] = 'required off'

# default['onddo_proftpd']['modules']['vroot']['vroot_engine'] = true
# default['onddo_proftpd']['modules']['vroot']['vroot_alias'] = '/var/ftp/upload upload'
# default['onddo_proftpd']['modules']['vroot']['virtual_host']['127.0.0.1'] = {
#   'vroot_engine' => true,
#   'vroot_server_root' => '/tmp',
#   'vroot_options' => %w{allowSymlinks},
#   'default_root' => '~',
# }
