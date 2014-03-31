default['onddo_proftpd']['conf_included_dirs'] = %w{modules conf.d}

# Set off to disable IPv6 support which is annoying on IPv4 only boxes.
default['onddo_proftpd']['use_ipv6'] = true
# If set on you can experience a longer connection delay in many cases
default['onddo_proftpd']['ident_lookups'] = false

default['onddo_proftpd']['server_name'] = 'ProFTPD'
default['onddo_proftpd']['server_type'] = 'standalone'
default['onddo_proftpd']['defer_welcome'] = false

default['onddo_proftpd']['multiline_rfc2228'] = true
default['onddo_proftpd']['default_server'] = true
default['onddo_proftpd']['show_symlinks'] = true

default['onddo_proftpd']['timeout_no_transfer'] = 600
default['onddo_proftpd']['timeout_stalled'] = 600
default['onddo_proftpd']['timeout_idle'] = 1200

default['onddo_proftpd']['display_login'] = 'welcome.msg'
default['onddo_proftpd']['display_chdir'] = '.message true'
default['onddo_proftpd']['list_options'] = '-l'

default['onddo_proftpd']['deny_filter'] = '\*.*/'

# Use this to jail all users in their homes
# default['onddo_proftpd']['default_root'] = '~'

# Users require a valid shell listed in /etc/shells to login.
# Use this directive to release that constrain.
# default['onddo_proftpd']['require_valid_shell'] = false

# Port 21 is the standard FTP port.
default['onddo_proftpd']['port'] = 21

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
# default['onddo_proftpd']['passive_ports'] = '49152 65534'

# If your host was NATted, this option is useful in order to
# allow passive tranfers to work. You have to use your public
# address and opening the passive ports used on your firewall as well.
# default['onddo_proftpd']['masquerade_address'] = '1.2.3.4'

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd)
default['onddo_proftpd']['max_instances'] = 30

# Set the user and group that the server normally runs at.
case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['onddo_proftpd']['user'] = 'nobody'
  default['onddo_proftpd']['group'] = 'nobody'
# when 'debian', 'ubuntu' then
else
  default['onddo_proftpd']['user'] = 'proftpd'
  default['onddo_proftpd']['group'] = 'nogroup'
end

# Umask 022 is a good standard umask to prevent new files and dirs
# (second parm) from being group and world writable.
default['onddo_proftpd']['umask'] = '022 022'
# Normally, we want files to be overwriteable.
default['onddo_proftpd']['allow_overwrite'] = true

# Uncomment this if you are using NIS or LDAP via NSS to retrieve passwords:
# default['onddo_proftpd']['persistent_passwd'] = false

# This is required to use both PAM-based authentication and local passwords
# default['onddo_proftpd']['auth_order'] = 'mod_auth_pam.c* mod_auth_unix.c'

# Be warned: use of this directive impacts CPU average load!
# Uncomment this if you like to see progress and transfer rate with ftpwho
# in downloads. That is not needed for uploads rates.
#

# default['onddo_proftpd']['use_send_file'] = false

default['onddo_proftpd']['transfer_log'] = '/var/log/proftpd/xferlog'
default['onddo_proftpd']['system_log'] = '/var/log/proftpd/proftpd.log'

# Logging onto /var/log/lastlog is enabled but set to off by default
# default['onddo_proftpd']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
# default['onddo_proftpd']['set_env']['TZ'] = ':/etc/localtime'

# default['onddo_proftpd']['virtual_hosts']['ftp.server.com'] = {
#   'server_admin' => 'ftpmaster@server.com',
#   'server_name' => 'Big FTP Archive',
#   'transfer_log' => '/var/log/proftpd/xfer/ftp.server.com',
#   'max_login_attempts' => 3,
#   'require_valid_shell' => false,
#   'default_root' => '/srv/ftp_root',
#   'allow_overwrite' => true,
# }

# default['onddo_proftpd']['anonymous']['~ftp'] = {
#   'user' => 'ftp',
#   'group' => 'nogroup',
#   'user_alias' => 'anonymous ftp',
#   'dir_fake_user' => 'on ftp',
#   'dir_fake_group' => 'on ftp',
#   'require_valid_shell' => false,
#   'max_clients' => 10,
#   'display_login' => 'welcome.msg',
#   'display_chdir' => '.message',
#   'directories' => {
#     '*' => {
#       'limits' => {
#         'write' => {
#           'deny_all' => nil,
#         },
#       },
#     },
#     'incoming' => {
#       'umask' => '022 022',
#       'limits' => {
#         'read write' => {
#           'deny_all' => nil,
#         },
#         'stor' => {
#           'allow_all' => nil,
#         },
#       },
#     },
#   },
# }
