#!/bin/bash

# Update hosts file
echo "[TASK 1] Update hosts file"
echo "$1" >> /etc/hosts

# Install docker
echo "[TASK 2] Install docker container engine"
# Update the package database
yum -y check-update
yum install -y -q yum-utils device-mapper-persistent-data lvm2
#yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
#yum install -y -q docker-ce >/dev/null 2>&1
# Add the official Docker repository, download the latest version of Docker, and install it
curl -fsSL https://get.docker.com/ | sh >/dev/null 2>&1
# Enable the Docker daemon to start at every server reboot
systemctl enable docker
# Start the Docker daemon
systemctl start docker
# Add your username to the docker group. To avoid typing sudo whenever user runs the docker command
usermod -aG docker $(whoami)

# Disable SELinux
echo "[TASK 3] Disable SELinux"
# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Disable firewalld
echo "[TASK 4] Disable firewalld"
# Stop the firewalld service
systemctl stop firewalld
# Disable the firewalld service to start automatically on system boot
systemctl disable firewalld >/dev/null 2>&1
# Mask the firewalld service which will prevent the firewall from being started by other services
systemctl mask --now firewalld

# Update IPtables
echo "[TASK 5] Update IPtables"
# Ensure traffic being routed correctly
cat <<EOF >  /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable SWAP
echo "[TASK 6] Disable SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Install Kubernetes
echo "[TASK 7] Install Kubernetes"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
yum install -y -q kubelet kubeadm kubectl --disableexcludes=kubernetes >/dev/null 2>&1
systemctl enable --now kubelet >/dev/null 2>&1

# Enable SSH password authentication
echo "[TASK 8] Enable SSH password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 9] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm-256color" >> /etc/bashrc