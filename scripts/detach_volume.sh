#!/bin/bash

CONFIG="centos8-minicube.json"
ESXI_USER="root"
SECRET_ID="host/sexiboy/user/$ESXI_USER"
SECRET_KEY="password"
DEPLOY_HOST=`cat $CONFIG|jq --raw-output '.variables.deploy_host'`
ESXI_PASSWORD=`aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq --raw-output '.SecretString' | jq -r ."$SECRET_KEY"`

HOSTNAME=`cat $CONFIG|jq --raw-output '.variables.hostname'`

sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$DEPLOY_HOST" sh" << EOF
echo $CONFIG > farts.txt
export FARTS="tasty"
echo "$FARTS" >> farts.txt

EOF"
