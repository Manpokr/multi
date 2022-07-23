#!/bin/bash
# Trojan GFW
# ==================

# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

# Validate Your IP Address
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
clear

IP=$( curl -s ipinfo.io/ip );
uuid=$(cat /etc/trojan/uuid.txt)
source /var/lib/manpokr/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
fi

tr="$(cat ~/log-install.txt | grep -i "Trojan-GFW" | cut -d: -f2|sed 's/ //g')"
user=TRIAL`</dev/urandom tr -dc c-z | head -c4`
exp=1
domain=$(cat /etc/v2ray/domain)
read -p "SNI (BUG) : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain

sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan

# // Link
trojanlink="trojan://${user}@${dom}:${tr}?sni=$sni#$user"
clear
echo -e "================================="
echo -e "       TROJAN  GFW  TRIAL       "
echo -e "================================="
echo -e "Remarks   : ${user}"
echo -e "IP/Host   : ${MYIP}"
echo -e "Domain    : ${domain}"
echo -e "Subdomain : $dom"
echo -e "Port      : ${tr}"
echo -e "Key       : ${user}"
echo -e "================================="
echo -e "Link TR  : ${trojanlink}"
echo -e "================================="
echo -e "Created   : $hariini"
echo -e "Expired   : $exp"
echo -e "================================="

echo -e "Script By Manternet"
