#!/bin/bash
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                        
ORANGE='\033[0;33m'
BLUE='\033[0;34m'                                                                                         
PURPLE='\033[0;35m'
CYAN='\033[0;36m'                                                                                         
NC='\033[0;37m'
LIGHT='\033[0;37m'

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"

clear
domain=$(cat /etc/xray/domain)
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[30;5;47m         ⇱ CERT / RENEW DOMAIN ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "" 
sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
clear
cd .acme.sh
echo "${RED}starting....,${NC}" 
echo "Port 80 Akan di Hentikan Saat Proses install Cert"    

# // Update Sertificate SSL
echo "Automatical Update Your Sertificate SSL"
sleep 3
echo Starting Update SSL Sertificate
sleep 0.5
source /var/lib/manpokr/ipvps.conf
domain=$IP
systemctl stop nginx
systemctl stop xray
systemctl stop xray.service
systemctl stop trojan
systemctl stop trojan.service
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
systemctl daemon-reload
systemctl restart nginx
systemctl daemon-reload
systemctl restart trojan
systemctl restart trojan.service
systemctl restart xray
systemctl restart xray.service
echo ""
echo Done
echo ""
sleep 2
clear
neofetch
