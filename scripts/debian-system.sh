#!/bin/bash -eux
## Original script from https://github.com/tsugliani/packer-vsphere-debian-appliances
##
## Debian system
## Install system utilities
##

echo '> Installing System Utilities...'

apt-get install -y \
  jq \
  grc \
  git \
  tmux \
  htop \
  unzip \
  vim

echo '> Done'