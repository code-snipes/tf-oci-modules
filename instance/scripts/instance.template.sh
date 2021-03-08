#!/bin/bash
exec 1> /var/log/cloud-init.log 2>&1

yum -y -t update --security
sed -i -e "s/autoinstall\s=\sno/# autoinstall = yes/g" /etc/uptrack/uptrack.conf
uptrack-upgrade -y
pip3 install oci-cli