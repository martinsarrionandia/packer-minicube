#!/bin/bash

# Set Root passwd

echo root:$ROOT_PASS | chpasswd

# Scedule remove vagrant user via inception

cat << EOF > /root/remove_vagrant.sh
userdel -f -r vagrant
rm -f /etc/sudoers.d/vagrant
rm -f /root/remove_vagrant.sh 
sed -i '/remove_vagrant\.sh/d' /etc/rc.d/rc.local
chmod -x /etc/rc.d/rc.local
EOF

chmod 755 /root/remove_vagrant.sh
chmod +x /etc/rc.d/rc.local
echo "/root/remove_vagrant.sh" >> /etc/rc.d/rc.local
