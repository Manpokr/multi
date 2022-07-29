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
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

# // Getting
MYIP=$(wget -qO- ifconfig.me/ip); 
echo "Checking VPS" 
IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $MYIP ) 
if [[ $MYIP = $IZIN ]]; then 
echo -e "${GREEN}Permission Accepted...${NC}" 
else 
echo -e "${RED}Permission Denied!${NC}"; 
echo -e "${LIGHT}Please Contact Admin!!" 
rm -f certv2ray
exit 0
fi
clear

# // Renew Cert
timedatectl set-timezone Asia/Kuala_Lumpur
date

sleep 0.5
domain=$(cat /etc/mon/xray/domain)
source /var/lib/manpokr/ipvps.conf
domain=$IP

# // ###
clear
echo -e "\033[0;32mstarting........\033[m"
echo -e "Port ${RED}80${NC} Akan di Hentikan Saat Proses install Cert"
echo -e ""
sleep 2

sudo pkill -f nginx & wait $!
systemctl stop nginx
systemctl stop xray
systemctl stop xray.service
systemctl stop trojan
systemctl stop trojan.service

source ~/.bashrc
if nc -z localhost 443;then /etc/init.d/nginx stop;fi

~/.acme.sh/acme.sh --issue -d "$domain" -k ec-256 --force --alpn >> /etc/mon/tls/$domain.log
~/.acme.sh/acme.sh --installcert -d "$domain" --fullchainpath /etc/mon/xray/xray.crt --keypath /etc/mon/xray/xray.key --ecc

cat /etc/mon/tls/$domain.log
systemctl daemon-reload
systemctl restart nginx
systemctl restart xray
systemctl restart xray.service
systemctl restart trojan
systemctl restart trojan.service

#cd .acme.sh


#systemctl stop nginx
#systemctl stop v2ray
#systemctl stop v2ray.service
#systemctl stop xray
#systemctl stop xray.service
#systemctl stop trojan
#systemctl stop trojan.service
#cd acme.sh
#bash acme.sh --set-default-ca --server letsencrypt
#bash acme.sh --issue -d $domain --standalone -k ec-256 --listen-v6 --force
#bash acme.sh --installcert -d $domain --fullchainpath /etc/mon/xray/xray.crt --keypath /etc/mon/xray/xray.key --ecc
#sleep 2

#systemctl daemon-reload
#systemctl restart nginx
#systemctl daemon-reload
#systemctl restart trojan
#systemctl restart trojan.service
#systemctl restart xray
#systemctl restart xray.service
echo ""
echo Done
echo ""
sleep 2
clear
neofetch
