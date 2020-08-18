#!/bin/bash

# Install KVM

ADMIN_USER="kubeadmin"


yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools conntrack

systemctl start libvirtd
systemctl enable libvirtd

# Add kubeadmin user

useradd $ADMIN_USER

sudo usermod -a -G libvirt  $ADMIN_USER

# Change libvirtd socket settings

sed -e 's/^.*unix_sock_group.*$/unix_sock_group = "libvirt"/' -i /etc/libvirt/libvirtd.conf
sed -e 's/^.*unix_sock_rw_perms.*$/unix_sock_rw_perms = "0770"/' -i /etc/libvirt/libvirtd.conf
systemctl restart libvirtd.service

# Install Docker

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce --nobest -y

# Get Minicube

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod 755 minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube

# Get Kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod 755 kubectl
mv kubectl /usr/local/bin

# Set driver

minikube config set driver docker
