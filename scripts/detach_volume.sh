#!/bin/bash

CONFIG="centos8-minicube.json"
ESXI_USER="root"
SECRET_ID="host/sexiboy/user/$ESXI_USER"
SECRET_KEY="password"
DEPLOY_HOST=$( < $CONFIG jq --raw-output '.variables.deploy_host')
ESXI_PASSWORD=$(aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq --raw-output '.SecretString' | jq -r ."$SECRET_KEY")
DISPLAY_NAME=$( < $CONFIG jq --raw-output '.variables.display_name')
CONTROLLER=$( < $CONFIG jq --raw-output '.variables.volume_disk_controller')
TARGET=$( < $CONFIG jq --raw-output '.variables.volume_disk_target')

# Get VMID from DISPLAY_NAME
VMID=$(sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$DEPLOY_HOST" sh" << EOF
vim-cmd vmsvc/getallvms | grep $DISPLAY_NAME | cut -d \" \" -f1
EOF")

# Detach Disk
sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$DEPLOY_HOST" sh" << EOF
vim-cmd vmsvc/device.diskremove $VMID $CONTROLLER $TARGET pvscsi
EOF"
