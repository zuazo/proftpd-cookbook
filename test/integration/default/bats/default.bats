#!/usr/bin/env bats

@test "proftpd should be running" {
  ps axu | grep -q 'proftp[d]'
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

@test "should not let you connect using an incorrect user" {
  ! curl -3 --list-only ftp://anonymous@localhost/
}
