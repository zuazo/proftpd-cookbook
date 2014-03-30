case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['onddo_proftpd']['modules']['ldap']['packages'] = %w{proftpd-ldap}
  default['onddo_proftpd']['modules']['sql_mysql']['packages'] = %w{proftpd-mysql}
  default['onddo_proftpd']['modules']['sql_postgres']['packages'] = %w{proftpd-postgresql}
# when 'debian', 'ubuntu' then
else
  default['onddo_proftpd']['modules']['autohost']['packages'] = %w{proftpd-mod-autohost}
  default['onddo_proftpd']['modules']['case']['packages'] = %w{proftpd-mod-case}
  default['onddo_proftpd']['modules']['clamav']['packages'] = %w{proftpd-mod-clamav}
  default['onddo_proftpd']['modules']['dnsbl']['packages'] = %w{proftpd-mod-dnsbl}
  default['onddo_proftpd']['modules']['fsync']['packages'] = %w{proftpd-mod-fsync}
  default['onddo_proftpd']['modules']['geoip']['packages'] = %w{proftpd-mod-geoip}
  default['onddo_proftpd']['modules']['ldap']['packages'] = %w{proftpd-mod-ldap}
  default['onddo_proftpd']['modules']['msg']['packages'] = %w{proftpd-mod-msg}
  default['onddo_proftpd']['modules']['sql_mysql']['packages'] = %w{proftpd-mod-mysql}
  default['onddo_proftpd']['modules']['sql_odbc']['packages'] = %w{proftpd-mod-odbc}
  default['onddo_proftpd']['modules']['sql_postgres']['packages'] = %w{proftpd-mod-pgsql}
  default['onddo_proftpd']['modules']['sql_sqlite']['packages'] = %w{proftpd-mod-sqlite}
  default['onddo_proftpd']['modules']['tar']['packages'] = %w{proftpd-mod-tar}
  default['onddo_proftpd']['modules']['vroot']['packages'] = %w{proftpd-mod-vroot}
end
