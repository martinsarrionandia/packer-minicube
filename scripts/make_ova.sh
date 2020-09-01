#!/bin/bash

if [ ! -d $OVA_DIR ]
then
  echo "$OVA_DIR not found or mounted."
  exit 10;
fi

pwd
cd output-vmware-iso
pwd
ovftool packer-vmware-iso.vmx $NEWHOSTNAME.ova
cp $NEWHOSTNAME.ova $OVA_DIR
