default['onddo_proftpd']['modules']['ctrls_admin']['conf_prefix'] = 'AdminControls'
default['onddo_proftpd']['modules']['ctrls_admin']['conf']['engine'] = false

default['onddo_proftpd']['modules']['ctrls']['conf_prefix'] = 'Controls'
default['onddo_proftpd']['modules']['ctrls']['conf']['controls_engine'] = false
default['onddo_proftpd']['modules']['ctrls']['conf']['controls_max_clients'] = 2
default['onddo_proftpd']['modules']['ctrls']['conf']['controls_log'] = '/var/log/proftpd/controls.log'
default['onddo_proftpd']['modules']['ctrls']['conf']['controls_interval'] = 5
default['onddo_proftpd']['modules']['ctrls']['conf']['controls_socket'] = '/var/run/proftpd/proftpd.sock'

# Delay engine reduces impact of the so-called Timing Attack described in
# http://www.securityfocus.com/bid/11430/discuss
# It is on by default.
default['onddo_proftpd']['modules']['delay']['conf_prefix'] = 'Delay'
default['onddo_proftpd']['modules']['delay']['conf']['delay_engine'] = true

# This is useful for masquerading address with dynamic IPs:
# refresh any configured MasqueradeAddress directives every 8 hours
# default['onddo_proftpd']['modules']['delay']['conf']['dyn_masq_refresh'] = 28800

# This is used for ordinary LDAP connections, with or without TLS
default['onddo_proftpd']['modules']['ldap']['conf_prefix'] = 'LDAP'
# default['onddo_proftpd']['modules']['ldap']['conf']['server'] = 'ldap://ldap.example.com'
# default['onddo_proftpd']['modules']['ldap']['conf']['bind_DN'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# default['onddo_proftpd']['modules']['ldap']['conf']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

# To be set on only for LDAP/TLS on ordinary port, for LDAP+SSL see below
# default['onddo_proftpd']['modules']['ldap']['conf']['use_TLS'] = true

# This is used for encrypted LDAPS connections
# default['onddo_proftpd']['modules']['ldap']['conf']['server'] = 'ldaps://ldap.example.com'
# default['onddo_proftpd']['modules']['ldap']['conf']['bind_DN'] = '"cn=admin,dc=example,dc=com" "admin_password"'
# default['onddo_proftpd']['modules']['ldap']['conf']['users'] = 'dc=users,dc=example,dc=com (uid=%u) (uidNumber=%u)'

default['onddo_proftpd']['modules']['quotatab']['conf']['quota_engine'] = false

default['onddo_proftpd']['modules']['ratio']['conf']['ratios'] = false

# Choose a SQL backend among MySQL or PostgreSQL.
# Both modules are loaded in default configuration, so you have to specify the backend
# or comment out the unused module in /etc/proftpd/modules.conf.
# Use 'mysql' or 'postgres' as possible values.
default['onddo_proftpd']['modules']['sql']['conf_prefix'] = 'SQL'
# default['onddo_proftpd']['modules']['sql']['conf']['backend'] = 'mysql'

# default['onddo_proftpd']['modules']['sql']['conf']['engine'] = true
# default['onddo_proftpd']['modules']['sql']['conf']['authenticate'] = true

# Use a backend-crypted or a crypted password
# default['onddo_proftpd']['modules']['sql']['conf']['auth_types'] = %w{Crypt Plaintext}

# Use a backend-crypted or a crypted password
# default['onddo_proftpd']['modules']['sql']['conf']['auth_types'] = %w{Backend Crypt}

# Connection
# default['onddo_proftpd']['modules']['sql']['conf']['connect_info'] = 'proftpd@sql.example.com proftpd_user proftpd_password'

# Describes both users/groups tables
# default['onddo_proftpd']['modules']['sql']['conf']['user_info'] = %w{users userid passwd uid gid homedir shell}
# default['onddo_proftpd']['modules']['sql']['conf']['group_info'] = %w{groups groupname gid members}

default['onddo_proftpd']['modules']['tls']['conf_prefix'] = 'TLS'
# default['onddo_proftpd']['modules']['tls']['conf']['engine'] = true
# default['onddo_proftpd']['modules']['tls']['conf']['log'] = '/var/log/proftpd/tls.log'
# default['onddo_proftpd']['modules']['tls']['conf']['protocol'] = 'SSLv23'

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
# default['onddo_proftpd']['modules']['tls']['conf']['RSA_certificate_file'] = '/etc/ssl/certs/proftpd.crt'
# default['onddo_proftpd']['modules']['tls']['conf']['RSA_certificate_key_file'] = '/etc/ssl/private/proftpd.key'

# CA the server trusts...
# default['onddo_proftpd']['modules']['tls']['conf']['CA_certificate_file'] = '/etc/ssl/certs/CA.pem'
# ...or avoid CA cert and be verbose
# default['onddo_proftpd']['modules']['tls']['conf']['options'] = %w{NoCertRequest EnableDiags}
# ... or the same with relaxed session use for some clients (e.g. FireFtp)
# default['onddo_proftpd']['modules']['tls']['conf']['options'] = %w{NoCertRequest EnableDiags NoSessionReuseRequired}

# Per default drop connection if client tries to start a renegotiate
# This is a fix for CVE-2009-3555 but could break some clients.
# default['onddo_proftpd']['modules']['tls']['conf']['options'] = %w{AllowClientRenegotiations}

# Authenticate clients that want to use FTP over TLS?
# default['onddo_proftpd']['modules']['tls']['conf']['verify_client'] = false

# Are clients required to use FTP over TLS when talking to this server?
# default['onddo_proftpd']['modules']['tls']['conf']['required'] = true

# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
# default['onddo_proftpd']['modules']['tls']['conf']['renegotiate'] = 'required off'

# default['onddo_proftpd']['modules']['vroot']['conf']['vroot_engine'] = true
# default['onddo_proftpd']['modules']['vroot']['conf']['vroot_alias'] = 'upload /var/ftp/upload'
# default['onddo_proftpd']['modules']['vroot']['conf']['virtualhost']['name'] = 'a.b.c.d'
# default['onddo_proftpd']['modules']['vroot']['conf']['virtualhost']['vroot_engine'] = true
# default['onddo_proftpd']['modules']['vroot']['conf']['virtualhost']['vroot_server_root'] = '/etc/ftpd/a.b.c.d/'
# default['onddo_proftpd']['modules']['vroot']['conf']['virtualhost']['vroot_options'] = %w{allowSymlinks}
# default['onddo_proftpd']['modules']['vroot']['conf']['virtualhost']['default_root'] = '~'
