#!/bin/bash

cd output-vmware-iso

ovftool \
--allowExtraConfig \
--extraConfig:eth0.ipaddr="192.168.9.55" \
packer-vmware-iso.vmx \
$NEWHOSTNAME.ovf

#--network="Firewall Backend" \
#--nic:minikube,0="Firewall Backlend",true,MANUAL,1.2.3.4 \
#--prop:"ConfigNET.ipaddr.1"="1.1.1.2" --prop:"ConfigNET.gateway.1"="1.1.9.1" --prop:"ConfigNET.netmask.1"="255.255.255.0" \


