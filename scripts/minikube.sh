#!/bin/bash

# Add kubeadmin user

useradd $ADMIN_USER
chpasswd $ADMIN_USER:$ADMIN_PASS

# Install Docker

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce --nobest -y
systemctl enable --now docker

usermod -aG docker $ADMIN_USER
usermod -aG wheel $ADMIN_USER

# Install Conntrack

yum -y install conntrack

# Get Minicube

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod 755 minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube

# Get Kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod 755 kubectl
mv kubectl /usr/local/bin

# Set config options

FREEKB=$(cat /proc/meminfo |grep MemFree|awk '{print $2}')
FREEMB=$((FREEKB/1024))
BREATHSPACEMB=128
KUBEMEM=$((FREEMB-BREATHSPACEMB))

/usr/local/bin/minikube config set driver $DRIVER
/usr/local/bin/minikube config set cpus $CPUS
/usr/local/bin/minikube config set memory $KUBEMEM

# Start minikube

if [ "$DRIVER" == "docker" ]
then
  sudo -u $ADMIN_USER /usr/local/bin/minikube start
elif [ "$DRIVER" == "none" ]
then
  /usr/local/bin/minikube start
else
  echo "Didn't start driver $DRIVER"
fi
