#!/bin/bash

CONFIG="centos8-minicube.json"
ESXI_USER="root"
SECRET_ID="host/sexiboy/user/$ESXI_USER"
SECRET_KEY="password"
DEPLOY_HOST=$(cat $CONFIG|jq --raw-output '.variables.deploy_host')
ESXI_PASSWORD=$(aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq --raw-output '.SecretString' | jq -r ."$SECRET_KEY")
DISPLAY_NAME=$(cat $CONFIG|jq --raw-output '.variables.display_name')
DATASTORE=$(cat $CONFIG|jq --raw-output '.variables.volume_disk_datastore')
CONTROLLER=$(cat $CONFIG|jq --raw-output '.variables.volume_disk_controller')
TARGET=$(cat $CONFIG|jq --raw-output '.variables.volume_disk_target')
SIZE=$(cat $CONFIG|jq --raw-output '.variables.volume_disk_size')

# Get VMID from DISPLAY_NAME
VMID=$(sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$DEPLOY_HOST" sh" << EOF
vim-cmd vmsvc/getallvms | grep $DISPLAY_NAME | cut -d \" \" -f1
EOF")

# Attach Disk
sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$DEPLOY_HOST" sh" << EOF
vmkfstools --createvirtualdisk $SIZE --diskformat zeroedthick /vmfs/volumes/$DATASTORE/$DISPLAY_NAME/volume_disk.vmdk 2>1 > /dev/null 
vim-cmd vmsvc/device.diskaddexisting $VMID /vmfs/volumes/$DATASTORE/$DISPLAY_NAME/volume_disk.vmdk $CONTROLLER $TARGET pvscsi
EOF"
