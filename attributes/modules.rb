case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['proftpd']['module_path'] = '/usr/libexec/proftpd'
# when 'debian', 'ubuntu' then
else
  default['proftpd']['module_path'] = '/usr/lib/proftpd'
end

default['proftpd']['module_controls_acls'] = [
  'insmod,rmmod allow user root',
  'lsmod allow user *',
]

# we need to use an array to preserver the order
default['proftpd']['loaded_modules'] = %w{
  ctrls_admin tls radius quotatab quotatab_file
  quotatab_radius wrap rewrite load ban wrap2
  wrap2_file exec shaper ratio site_misc sftp
  sftp_pam facl ifsession
}
