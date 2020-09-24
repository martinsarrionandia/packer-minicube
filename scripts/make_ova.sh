#!/bin/bash

cd output-vmware-iso || exit

ovftool \
packer-vmware-iso.vmx \
"$NEWHOSTNAME".ova
