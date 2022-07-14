#!/bin/bash
# My Telegram : https://t.me/Manternet
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

# ==========================================
# Getting
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • DELETE XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""  
	read -p "Username : " user
	echo -e ""
	if ! grep -qw "$user" /etc/xray/clients.txt; then
		echo -e ""
        echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu   
	fi
uuid="$(cat /etc/xray/clients.txt | grep -w "$user" | awk '{print $2}')"

	cat /etc/mon/xray/conf/02_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/xray/conf/02_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/02_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/02_trojan_TCP_inbounds.json
    cat /etc/mon/xray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/xray/conf/03_VLESS_WS_inbounds.json
    cat /etc/mon/xray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_TCP_inbounds.json		
    cat /etc/mon/xray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/xray/conf/05_VMess_WS_inbounds.json
    sed -i "/\b$user $exp\b/d" /etc/xray/clients.txt



user=$(echo $expired | awk '{print $1}')
exp=$(echo $expired | awk '{print $3}')
#user=$(grep -E "^#&# " "/etc/xray/trojan.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
#exp=$(grep -E "^#&# " "/etc/xray/trojan.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
#sed -i "/^#&# $user $exp/,/^},{/d" /etc/xray/trojan.json
#sed -i "/^#&# $user $exp/,/^},{/d" /etc/xray/trojan.json
systemctl restart xray.service
#service cron restart
clear
echo ""
echo "================================"
echo "  Xray/Trojan Account Deleted  "
echo "================================"
echo "Username  : $user"
echo "Expired   : $exp"
echo "================================"
echo "Script By Manternet"
