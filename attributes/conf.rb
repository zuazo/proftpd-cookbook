default['onddo-proftpd']['conf'] = {}

# Set off to disable IPv6 support which is annoying on IPv4 only boxes.
default['onddo-proftpd']['conf']['use_ipv6'] = true
# If set on you can experience a longer connection delay in many cases
default['onddo-proftpd']['conf']['ident_lookups'] = false

default['onddo-proftpd']['conf']['server_name'] = 'ProFTPD'
default['onddo-proftpd']['conf']['server_type'] = 'standalone'
default['onddo-proftpd']['conf']['defer_welcome'] = false

default['onddo-proftpd']['conf']['multiline_rfc2228'] = true
default['onddo-proftpd']['conf']['default_server'] = true
default['onddo-proftpd']['conf']['show_symlinks'] = true

default['onddo-proftpd']['conf']['timeout_no_transfer'] = 600
default['onddo-proftpd']['conf']['timeout_stalled'] = 600
default['onddo-proftpd']['conf']['timeout_idle'] = 1200

default['onddo-proftpd']['conf']['display_login'] = 'welcome.msg'
default['onddo-proftpd']['conf']['display_chdir'] = '.message true'
default['onddo-proftpd']['conf']['list_options'] = '-l'

default['onddo-proftpd']['conf']['deny_filter'] = '\*.*/'

# Use this to jail all users in their homes
# default['onddo-proftpd']['conf']['default_root'] = '~'

# Users require a valid shell listed in /etc/shells to login.
# Use this directive to release that constrain.
# default['onddo-proftpd']['conf']['require_valid_shell'] = false

# Port 21 is the standard FTP port.
default['onddo-proftpd']['conf']['port'] = 21

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
# default['onddo-proftpd']['conf']['passive_ports'] = '49152 65534'

# If your host was NATted, this option is useful in order to
# allow passive tranfers to work. You have to use your public
# address and opening the passive ports used on your firewall as well.
# default['onddo-proftpd']['conf']['masquerade_address'] = '1.2.3.4'

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd)
default['onddo-proftpd']['conf']['max_instances'] = 30

# Set the user and group that the server normally runs at.
default['onddo-proftpd']['conf']['user'] = 'proftpd'
default['onddo-proftpd']['conf']['group'] = 'nogroup'

# Umask 022 is a good standard umask to prevent new files and dirs
# (second parm) from being group and world writable.
default['onddo-proftpd']['conf']['umask'] = '022 022'
# Normally, we want files to be overwriteable.
default['onddo-proftpd']['conf']['allow_overwrite'] = true

# Uncomment this if you are using NIS or LDAP via NSS to retrieve passwords:
# default['onddo-proftpd']['conf']['persistent_passwd'] = false

# This is required to use both PAM-based authentication and local passwords
# default['onddo-proftpd']['conf']['auth_order'] = 'mod_auth_pam.c* mod_auth_unix.c'

# Be warned: use of this directive impacts CPU average load!
# Uncomment this if you like to see progress and transfer rate with ftpwho
# in downloads. That is not needed for uploads rates.
#

# default['onddo-proftpd']['conf']['use_send_file'] = false

default['onddo-proftpd']['conf']['transfer_log'] = '/var/log/proftpd/xferlog'
default['onddo-proftpd']['conf']['system_log'] = '/var/log/proftpd/proftpd.log'

# Logging onto /var/log/lastlog is enabled but set to off by default
# default['onddo-proftpd']['conf']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
# default['onddo-proftpd']['conf']['set_env']['TZ'] = ':/etc/localtime'
