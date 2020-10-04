#!/bin/bash

hostnamectl set-hostname "$KUBE_HOSTNAME"

# Point hostname to docker bridge kubernetes container IP
# When minikube starts with the --apiserver-name=$KUBE_HOSTNAME 
# The hostname must point to here
echo "172.17.0.3  $KUBE_HOSTNAME" >> /etc/hosts