#!/bin/bash -eux
##
## Debian 
## Setup k8s pre-requisites
##

echo '> Installing containerd...'
# Install pre-requisites
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common

# Add docker repository & fetch update
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

#Install containerd
apt-get install -y containerd.io


# Replace containerd config to activate CRI et enable cgroup v2
containerd config default > /etc/containerd/config.toml
sed -ie 's/SystemdCgroup = .*/SystemdCgroup = true/' /etc/containerd/config.toml



#Restart containerd
systemctl restart containerd

echo '> Containerd installation done'

echo '> Configure system to match k8s prerequisites...'
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab




echo '> Installing CRI tools...'
# Add kubernetes repository
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# No need to update as the installation will be done at first startup
apt-get update
apt-get install -y cri-tools


# Configure crictl
cat <<EOF > /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
EOF
echo '> CRI tools installation done...'
