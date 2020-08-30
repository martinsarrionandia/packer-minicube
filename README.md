# packer-minicube


Requirements

VMWare Fusion. £3 from Ebay. £80 from VMWare.
AWS Secret manager

Secret Plain Text
```
{
  "kubeadmin": "Here is my password",
  "root": "Here is my other password"
}
```

To make AWS Secret Manager work you must set the ENV REGION like so.
EXPORT REGION="eu-west-2".


Set some variable in the json file

```packer build centos8-minicube.json```
