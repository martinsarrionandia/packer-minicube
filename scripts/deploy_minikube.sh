#!/bin/bash

CONFIG="centos8-minicube.json"
ESXI_USER="root"
SECRET_ID="host/sexiboy/user/$ESXI_USER"
SECRET_KEY="password"
DEPLOY_HOST=`cat $CONFIG|jq --raw-output '.variables.deploy_host'`
DEPLOY_NETWORK=`cat $CONFIG|jq --raw-output '.variables.deploy_network'`
DEPLOY_DATASTORE=`cat $CONFIG|jq --raw-output '.variables.deploy_datastore'`
ESXI_PASSWORD=`aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq --raw-output '.SecretString' | jq -r ."$SECRET_KEY"`

HOSTNAME=`cat $CONFIG|jq --raw-output '.variables.hostname'`

cd output-vmware-iso

ovftool \
--parallelThreads=4 \
--datastore="$DEPLOY_DATASTORE" \
--network="$DEPLOY_NETWORK" \
--allowExtraConfig \
--extraConfig:eth0.ipaddr="192.168.9.55" \
--X:injectOvfEnv \
--powerOn \
minikube.ovf \
"vi://"$ESXI_USER":"$ESXI_PASSWORD"@"$DEPLOY_HOST""
