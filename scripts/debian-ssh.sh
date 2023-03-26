#!/bin/bash -eux
##
## Debian Settings
## Renew SSH Keys
##

# Remove old keys
rm -f /etc/ssh/ssh_host_*
# Reconfigure openssh-server to generate new keys
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure openssh-server