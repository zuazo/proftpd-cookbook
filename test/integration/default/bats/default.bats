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

@test "should let you connect using a valid system user" {
  curl -3 --list-only ftp://user1:user1@localhost/ > /dev/null
}

@test "should let you connect using TLS" {
  curl -3 --insecure --list-only --ftp-ssl ftp://user1:user1@localhost/ > /dev/null
}

@test "should let you connect using an anonymous user" {
  curl -3 --list-only ftp://anonymous@localhost/
}

@test "should not let you connect using an incorrect user" {
  ! curl -3 --list-only ftp://baduser:baduser@localhost/
}
