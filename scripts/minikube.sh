#!/bin/bash

# Add kubeadmin user

useradd $ADMIN_USER
echo $ADMIN_USER:$ADMIN_PASS | chpasswd

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

curl -LO https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl
chmod 755 kubectl
mv kubectl /usr/local/bin

# Set config options

FREEKB=$( < /proc/meminfo grep MemFree|awk '{print $2}')
FREEMB=$((FREEKB/1024))
BREATHSPACEMB=128
KUBEMEM=$((FREEMB-BREATHSPACEMB))

# Set config for root.
# Only root can run driver none

/usr/local/bin/minikube config set driver none
/usr/local/bin/minikube config set cpus "$CPUS"
/usr/local/bin/minikube config set memory "$KUBEMEM"

# Set config for kubeadmin
# Only kubeadmin can run driver docker

su "$ADMIN_USER" << 'EOF'
/usr/local/bin/minikube config set driver docker
/usr/local/bin/minikube config set cpus "$CPUS"
/usr/local/bin/minikube config set memory "$KUBEMEM"
EOF

# Start minikube

if [ "$DRIVER" == "docker" ]
then

cat << EOF > /etc/systemd/system/minikube.service
[Unit]
Description = Minikube Service
After = docker.service

[Service]
User="$ADMIN_USER"
ExecStart = /usr/local/bin/minikube start
ExecStop = /usr/local/bin/minikube stop
ExecReload = /usr/local/bin/minikube stop ; /usr/local/bin/minikube start
RemainAfterExit = yes

[Install]
WantedBy = multi-user.target
EOF

systemctl enable minikube.service

elif [ "$DRIVER" == "none" ]
then
  /usr/local/bin/minikube start && systemctl enable kubelet
else
  echo "Didn't start driver $DRIVER"
fi
