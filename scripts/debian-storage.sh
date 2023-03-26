#!/bin/bash -eux
## Original script from https://github.com/tsugliani/packer-vsphere-debian-appliances
##
## Debian Storage
## Install Storage utilities
##

echo '> Installing Storage utilities...'

apt-get install -y \
  pydf \
  yafc \
  pure-ftpd \
  nfs-kernel-server

echo '> Done'