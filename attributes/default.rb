# Set off to disable IPv6 support which is annoying on IPv4 only boxes.
default['proftpd']['use_ipv6'] = true
# If set on you can experience a longer connection delay in many cases
default['proftpd']['ident_lookups'] = false

default['proftpd']['server_name'] = 'ProFTPD'
default['proftpd']['server_type'] = 'standalone'
default['proftpd']['defer_welcome'] = false

default['proftpd']['multiline_rfc2228'] = true
default['proftpd']['default_server'] = true
default['proftpd']['show_symlinks'] = true

default['proftpd']['timeout_no_transfer'] = 600
default['proftpd']['timeout_stalled'] = 600
default['proftpd']['timeout_idle'] = 1200

default['proftpd']['display_login'] = 'welcome.msg'
default['proftpd']['display_chdir'] = '.message true'
default['proftpd']['list_options'] = '-l'

default['proftpd']['deny_filter'] = '\*.*/'

# Use this to jail all users in their homes
# default['proftpd']['default_root'] = '~'

# Users require a valid shell listed in /etc/shells to login.
# Use this directive to release that constrain.
# default['proftpd']['require_valid_shell'] = false

# Port 21 is the standard FTP port.
default['proftpd']['port'] = 21

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
# default['proftpd']['passive_ports'] = '49152 65534'

# If your host was NATted, this option is useful in order to
# allow passive tranfers to work. You have to use your public
# address and opening the passive ports used on your firewall as well.
# default['proftpd']['masquerade_address'] = '1.2.3.4'

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd)
default['proftpd']['max_instances'] = 30

# Set the user and group that the server normally runs at.
case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['proftpd']['user'] = 'nobody'
  default['proftpd']['group'] = 'nobody'
# when 'debian', 'ubuntu' then
else
  default['proftpd']['user'] = 'proftpd'
  default['proftpd']['group'] = 'nogroup'
end

# Umask 022 is a good standard umask to prevent new files and dirs
# (second parm) from being group and world writable.
default['proftpd']['umask'] = '022 022'
# Normally, we want files to be overwriteable.
default['proftpd']['allow_overwrite'] = true

# Uncomment this if you are using NIS or LDAP via NSS to retrieve passwords:
# default['proftpd']['persistent_passwd'] = false

# This is required to use both PAM-based authentication and local passwords
# default['proftpd']['auth_order'] = 'mod_auth_pam.c* mod_auth_unix.c'

# Be warned: use of this directive impacts CPU average load!
# Uncomment this if you like to see progress and transfer rate with ftpwho
# in downloads. That is not needed for uploads rates.
#

# default['proftpd']['use_sendfile'] = false

default['proftpd']['transfer_log'] = '/var/log/proftpd/xferlog'
default['proftpd']['system_log'] = '/var/log/proftpd/proftpd.log'

# Logging onto /var/log/lastlog is enabled but set to off by default
# default['proftpd']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
# default['proftpd']['set_env']['TZ'] = ':/etc/localtime'

# default['proftpd']['virtual_host']['ftp.server.com'] = {
#   'server_admin' => 'ftpmaster@server.com',
#   'server_name' => 'Big FTP Archive',
#   'transfer_log' => '/var/log/proftpd/xfer/ftp.server.com',
#   'max_login_attempts' => 3,
#   'require_valid_shell' => false,
#   'default_root' => '/srv/ftp_root',
#   'allow_overwrite' => true,
# }

# default['proftpd']['anonymous']['~ftp'] = {
#   'user' => 'ftp',
#   'group' => 'nogroup',
#   'user_alias' => 'anonymous ftp',
#   'dir_fake_user' => 'on ftp',
#   'dir_fake_group' => 'on ftp',
#   'require_valid_shell' => false,
#   'max_clients' => 10,
#   'display_login' => 'welcome.msg',
#   'display_chdir' => '.message',
#   'directory' => {
#     '*' => {
#       'limit' => {
#         'write' => {
#           'deny_all' => nil,
#         },
#       },
#     },
#     'incoming' => {
#       'umask' => '022 022',
#       'limit' => {
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
