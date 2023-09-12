#!/usr/bin/env bash

sshd=$(readlink -f $(which sshd))
exec $sshd -D -e
