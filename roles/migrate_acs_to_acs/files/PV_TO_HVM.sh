#!/bin/bash
# Configure GRUB2 for PV to HVM conversion

apt-get purge -y grub* 2>&1 > /dev/null

mkdir -p /boot/grub
#echo "grub-pc grub-pc/install_devices_empty   boolean true" | debconf-set-selections
DEBIAN_FRONTEND=text apt-get install --assume-yes --no-install-recommends grub-pc-bin grub2-common
grub-install /dev/xvda

grub-mkconfig -o /boot/grub/grub.cfg

cat << EOF > /etc/default/grub
GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX="console=ttyS0,115200 net.ifnames=0 biosdevname=0"
EOF

update-grub

uuid_disk=$(blkid |grep /dev/xvda1 |cut -d'"' -f4)
sed -i ":/dev/mapper/tapdev0p1:UUID=${uuid_disk}:" /boot/grub/grub.cfg

touch /tmp/pv_to_hvm_ok.txt
