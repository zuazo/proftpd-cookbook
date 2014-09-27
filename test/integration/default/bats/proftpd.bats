#!/usr/bin/env bats

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

@test "proftpd should be running" {
  ps axu | grep -q 'proftp[d]'
}

@test "proftpd should be listening" {
  lsof -itcp:'21' -a -c'proftpd'
}

@test "proftpd should have a correct syntax file" {
  proftpd --configtest > /dev/null
}

@test "proftpd -vv should run without errors" {
  proftpd -vv > /dev/null
}
