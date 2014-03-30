# Set off to disable IPv6 support which is annoying on IPv4 only boxes.
default['onddo_proftpd']['conf']['use_ipv6'] = true
# If set on you can experience a longer connection delay in many cases
default['onddo_proftpd']['conf']['ident_lookups'] = false

default['onddo_proftpd']['conf']['server_name'] = 'ProFTPD'
default['onddo_proftpd']['conf']['server_type'] = 'standalone'
default['onddo_proftpd']['conf']['defer_welcome'] = false

default['onddo_proftpd']['conf']['multiline_rfc2228'] = true
default['onddo_proftpd']['conf']['default_server'] = true
default['onddo_proftpd']['conf']['show_symlinks'] = true

default['onddo_proftpd']['conf']['timeout_no_transfer'] = 600
default['onddo_proftpd']['conf']['timeout_stalled'] = 600
default['onddo_proftpd']['conf']['timeout_idle'] = 1200

default['onddo_proftpd']['conf']['display_login'] = 'welcome.msg'
default['onddo_proftpd']['conf']['display_chdir'] = '.message true'
default['onddo_proftpd']['conf']['list_options'] = '-l'

default['onddo_proftpd']['conf']['deny_filter'] = '\*.*/'

# Use this to jail all users in their homes
# default['onddo_proftpd']['conf']['default_root'] = '~'

# Users require a valid shell listed in /etc/shells to login.
# Use this directive to release that constrain.
# default['onddo_proftpd']['conf']['require_valid_shell'] = false

# Port 21 is the standard FTP port.
default['onddo_proftpd']['conf']['port'] = 21

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
# default['onddo_proftpd']['conf']['passive_ports'] = '49152 65534'

# If your host was NATted, this option is useful in order to
# allow passive tranfers to work. You have to use your public
# address and opening the passive ports used on your firewall as well.
# default['onddo_proftpd']['conf']['masquerade_address'] = '1.2.3.4'

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd)
default['onddo_proftpd']['conf']['max_instances'] = 30

# Set the user and group that the server normally runs at.
default['onddo_proftpd']['conf']['user'] = 'proftpd'
default['onddo_proftpd']['conf']['group'] = 'nogroup'

# Umask 022 is a good standard umask to prevent new files and dirs
# (second parm) from being group and world writable.
default['onddo_proftpd']['conf']['umask'] = '022 022'
# Normally, we want files to be overwriteable.
default['onddo_proftpd']['conf']['allow_overwrite'] = true

# Uncomment this if you are using NIS or LDAP via NSS to retrieve passwords:
# default['onddo_proftpd']['conf']['persistent_passwd'] = false

# This is required to use both PAM-based authentication and local passwords
# default['onddo_proftpd']['conf']['auth_order'] = 'mod_auth_pam.c* mod_auth_unix.c'

# Be warned: use of this directive impacts CPU average load!
# Uncomment this if you like to see progress and transfer rate with ftpwho
# in downloads. That is not needed for uploads rates.
#

# default['onddo_proftpd']['conf']['use_send_file'] = false

default['onddo_proftpd']['conf']['transfer_log'] = '/var/log/proftpd/xferlog'
default['onddo_proftpd']['conf']['system_log'] = '/var/log/proftpd/proftpd.log'

# Logging onto /var/log/lastlog is enabled but set to off by default
# default['onddo_proftpd']['conf']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
# default['onddo_proftpd']['conf']['set_env']['TZ'] = ':/etc/localtime'
