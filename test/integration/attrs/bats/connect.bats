#!/usr/bin/env bats

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
