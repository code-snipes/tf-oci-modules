#!/bin/bash
exec 1> /var/log/cloud-init.script 2>&1

yum -y -t update --security
sed -i -e "s/autoinstall\s=\sno/# autoinstall = yes/g" /etc/uptrack/uptrack.conf
uptrack-upgrade -y
pip3 install oci-cli

sudo -i -u opc bash << END
mkdir ~/.oci
touch ~/.oci/config
chmod 600 ~/.oci/config
cat << EOF > ~/.oci/config
[DEFAULT]
user=ocid1.user.XXXXXX<----- YourUserOcID-Here
fingerprint=00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 <---- YourUserFingerprintID-Here
tenancy=ocid1.tenancy.oc1.XXXXXXXXXX <----- YourTenancyOcID-Here
region=eu-frankfurt-1 <---- CHANGE THE REGION TO YOUR REGION
key_file=~/.oci/oci-api-key.pem
EOF
touch ~/.oci/oci-api-key.pem
chmod 600 ~/.oci/oci-api-key.pem
cat <<'EOF' > ~/.oci/oci-api-key.pem
-----BEGIN PRIVATE KEY-----
........KEY-CONTENT-HERE......
-----END PRIVATE KEY-----
EOF
END