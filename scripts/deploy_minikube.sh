#!/bin/bash

CONFIG="centos8-minicube.json"
ESXI_USER="root"
SECRET_ID="host/sexiboy/user/$ESXI_USER"
SECRET_KEY="password"
ESXI_PASSWORD=`aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq --raw-output '.SecretString' | jq -r ."$SECRET_KEY"`

MEMORY=`cat $CONFIG|jq --raw-output '.variables.memory'`
CPUS=`cat $CONFIG|jq --raw-output '.variables.cpus'`

echo $ESXI_PASSWORD
echo $MEMORY
ECHO $CPUS


