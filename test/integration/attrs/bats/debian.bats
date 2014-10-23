#!/usr/bin/env bats

@test "should include modules.conf in proftpd.conf config file" {
  egrep -qi "^[[:space:]]*Include.*/etc/proftpd/modules.conf" /etc/proftpd/proftpd.conf
}
