default['onddo_proftpd']['module_path'] = '/usr/lib/proftpd'

default['onddo_proftpd']['module_controls_acls'] = [
  'insmod,rmmod allow user root',
  'lsmod allow user *',
]

# we need to use an array to preserver the order
default['onddo_proftpd']['loaded_modules'] = %w{
  ctrls_admin tls radius quotatab quotatab_file
  quotatab_radius wrap rewrite load ban wrap2
  wrap2_file dynmasq exec shaper ratio site_misc
  sftp sftp_pam facl unique_id copy deflate ifversion
  tls_memcache ifsession
}
