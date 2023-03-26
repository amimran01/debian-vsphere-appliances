#!/bin/bash -eux
## Original script from https://github.com/tsugliani/packer-vsphere-debian-appliances
##
## Debian Network
## Install Network utilities
##


echo '> Installing Network utilities...'

apt-get install -y \
  ntp \
  frr \
  curl \
  wget \
  rsync \
  telnet \
  netcat \
  dnsmasq \
  mtr-tiny \
  speedometer \
  bridge-utils \
  tcpdump

echo '> Done'
