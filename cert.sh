#!/bin/bash
# XRay Installation
# Mod by Manternet
# ==================================
RED='\e[1;31m'
GREEN='\e[0;32m'
NC='\e[0m'

# // Domain
domain=$(cat /root/domain)
domain=$(cat /etc/xray/domain)
# // Install Cert
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
sudo pkill -f nginx & wait $!
systemctl stop nginx
sleep 2

# // Acme
/root/.acme.sh/acme.sh  --upgrade  --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --register-account -m anjang614@gmail.com
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 --server letsencrypt >> /etc/tls/$domain.log
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
cat /etc/tls/$domain.log
systemctl daemon-reload
systemctl restart nginx
service squid start

restart
echo -e "done"
sleep 2
clear
