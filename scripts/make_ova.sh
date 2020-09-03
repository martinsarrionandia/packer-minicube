#!/bin/bash

cd output-vmware-iso

ovftool \
packer-vmware-iso.vmx \
$NEWHOSTNAME.ova
