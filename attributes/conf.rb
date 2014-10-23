# encoding: UTF-8
#
# Cookbook Name:: onddo_proftpd
# Attributes:: conf
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

default['proftpd']['conf']['default_address'] = node['ipaddress']

# Set off to disable IPv6 support which is annoying on IPv4 only boxes.
default['proftpd']['conf']['use_ipv6'] = true
# If set on you can experience a longer connection delay in many cases
default['proftpd']['conf']['ident_lookups'] = false

default['proftpd']['conf']['server_name'] = 'ProFTPD'
default['proftpd']['conf']['server_type'] = 'standalone'
default['proftpd']['conf']['defer_welcome'] = false

default['proftpd']['conf']['multiline_rfc2228'] = true
default['proftpd']['conf']['default_server'] = true
default['proftpd']['conf']['show_symlinks'] = true

default['proftpd']['conf']['timeout_no_transfer'] = 600
default['proftpd']['conf']['timeout_stalled'] = 600
default['proftpd']['conf']['timeout_idle'] = 1200

default['proftpd']['conf']['display_login'] = 'welcome.msg'
default['proftpd']['conf']['display_chdir'] = '.message true'
default['proftpd']['conf']['list_options'] = '-l'

default['proftpd']['conf']['deny_filter'] = '\*.*/'

# Use this to jail all users in their homes
# default['proftpd']['conf']['default_root'] = '~'

# Users require a valid shell listed in /etc/shells to login.
# Use this directive to release that constrain.
# default['proftpd']['conf']['require_valid_shell'] = false

# Port 21 is the standard FTP port.
default['proftpd']['conf']['port'] = 21

# In some cases you have to specify passive ports range to by-pass
# firewall limitations. Ephemeral ports can be used for that, but
# feel free to use a more narrow range.
# default['proftpd']['conf']['passive_ports'] = '49152 65534'

# If your host was NATted, this option is useful in order to
# allow passive tranfers to work. You have to use your public
# address and opening the passive ports used on your firewall as well.
# default['proftpd']['conf']['masquerade_address'] = '1.2.3.4'

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd)
default['proftpd']['conf']['max_instances'] = 30

# Set the user and group that the server normally runs at.
case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['proftpd']['conf']['user'] = 'nobody'
  default['proftpd']['conf']['group'] = 'nobody'
# when 'debian', 'ubuntu' then
else
  default['proftpd']['conf']['user'] = 'proftpd'
  default['proftpd']['conf']['group'] = 'nogroup'
end

# Umask 022 is a good standard umask to prevent new files and dirs
# (second parm) from being group and world writable.
default['proftpd']['conf']['umask'] = '022 022'
# Normally, we want files to be overwriteable.
default['proftpd']['conf']['allow_overwrite'] = true

# Uncomment this if you are using NIS or LDAP via NSS to retrieve passwords:
# default['proftpd']['conf']['persistent_passwd'] = false

# This is required to use both PAM-based authentication and local passwords
# default['proftpd']['conf']['auth_order'] = 'mod_auth_pam.c* mod_auth_unix.c'

# Be warned: use of this directive impacts CPU average load!
# Uncomment this if you like to see progress and transfer rate with ftpwho
# in downloads. That is not needed for uploads rates.
#

# default['proftpd']['conf']['use_sendfile'] = false

default['proftpd']['conf']['transfer_log'] = '/var/log/proftpd/xferlog'
default['proftpd']['conf']['system_log'] = '/var/log/proftpd/proftpd.log'

# Logging onto /var/log/lastlog is enabled but set to off by default
# default['proftpd']['conf']['use_last_log'] = true

# In order to keep log file dates consistent after chroot, use timezone info
# from /etc/localtime.  If this is not set, and proftpd is configured to
# chroot (e.g. DefaultRoot or <Anonymous>), it will use the non-daylight
# savings timezone regardless of whether DST is in effect.
# default['proftpd']['conf']['set_env']['TZ'] = ':/etc/localtime'

# default['proftpd']['conf']['virtual_host']['ftp.server.com'] = {
#   'server_admin' => 'ftpmaster@server.com',
#   'server_name' => 'Big FTP Archive',
#   'transfer_log' => '/var/log/proftpd/xfer/ftp.server.com',
#   'max_login_attempts' => 3,
#   'require_valid_shell' => false,
#   'default_root' => '/srv/ftp_root',
#   'allow_overwrite' => true,
# }

# default['proftpd']['conf']['anonymous']['~ftp'] = {
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

default['proftpd']['conf']['include'] = %w{/etc/proftpd/conf.d}
