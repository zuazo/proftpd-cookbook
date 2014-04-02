case node['platform']
when 'redhat','centos','scientific','fedora','suse','amazon'
  default['proftpd']['modules']['ldap']['packages'] = %w{proftpd-ldap}
  default['proftpd']['modules']['sql_mysql']['packages'] = %w{proftpd-mysql}
  default['proftpd']['modules']['sql_postgres']['packages'] = %w{proftpd-postgresql}
# when 'debian', 'ubuntu' then
else
  default['proftpd']['modules']['autohost']['packages'] = %w{proftpd-mod-autohost}
  default['proftpd']['modules']['case']['packages'] = %w{proftpd-mod-case}
  default['proftpd']['modules']['clamav']['packages'] = %w{proftpd-mod-clamav}
  default['proftpd']['modules']['dnsbl']['packages'] = %w{proftpd-mod-dnsbl}
  default['proftpd']['modules']['fsync']['packages'] = %w{proftpd-mod-fsync}
  default['proftpd']['modules']['geoip']['packages'] = %w{proftpd-mod-geoip}
  default['proftpd']['modules']['ldap']['packages'] = %w{proftpd-mod-ldap}
  default['proftpd']['modules']['msg']['packages'] = %w{proftpd-mod-msg}
  default['proftpd']['modules']['sql_mysql']['packages'] = %w{proftpd-mod-mysql}
  default['proftpd']['modules']['sql_odbc']['packages'] = %w{proftpd-mod-odbc}
  default['proftpd']['modules']['sql_postgres']['packages'] = %w{proftpd-mod-pgsql}
  default['proftpd']['modules']['sql_sqlite']['packages'] = %w{proftpd-mod-sqlite}
  default['proftpd']['modules']['tar']['packages'] = %w{proftpd-mod-tar}
  default['proftpd']['modules']['vroot']['packages'] = %w{proftpd-mod-vroot}
end
