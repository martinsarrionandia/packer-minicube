#!/bin/bash

# Set Root passwd

chpasswd root:$ROOT_PASS

# Remove Vagrant User

userdel -r vagrant
