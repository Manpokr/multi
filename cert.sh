#!/bin/bash
# Cert Installation
# Mod by Manternet
# ==================================
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
LIGHT='\033[0;37m'

# // Date
timedatectl set-timezone Asia/Kuala_Lumpur
date

# // Domain
domain=$(cat /root/domain)

# // INSTALL ACME
sudo pkill -f nginx & wait $!
systemctl stop nginx
sleep 2

mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh

cd /root/
wget -O acme.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh

cd .acme.sh
sudo bash acme.sh --upgrade --auto-upgrade
sudo bash acme.sh --set-default-ca --server letsencrypt
sudo bash acme.sh --register-account -m anjang614@gmail.com
sudo bash acme.sh --issue -d $domain --standalone -k ec-256 --server letsencrypt >> /etc/tls/$domain.log
sudo bash acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

cat /etc/tls/$domain.log
systemctl daemon-reload
systemctl restart nginx
service squid start
systemctl restart xray.service
systemctl restart v2ray.service
systemctl restart trojan.service
echo -e "done"
sleep 2

clear
rm -f /root/cert.sh
rm -f cert.sh
