# packer-minicube


Requirements

VMWare Fusion. £3 from Ebay. £80 from VMWare.

AWS Secret manager


sshpass
```
brew install esolitos/ipa/sshpass
```

OVFTool 4.4
https://my.vmware.com/group/vmware/downloads/details?downloadGroup=OVFTOOL440&productId=967


Create a secret with path

Secret Plain Text
```
{
  "kubeadmin": "Here is my password",
  "root": "Here is my other password"
}
```

To make AWS Secret Manager work you must set the ENV REGION like so.
export AWS_REGION=eu-west-1

Set some variable in the json file

```packer build centos8-minicube.json```


Please run ```scripts/deploy_ova.sh``` from root dir


Make the filesystem yourself!!
```
mkfs.xfs /dev/sdb
```

eagerzeroedthic
