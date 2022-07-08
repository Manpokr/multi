#!/bin/bash
# Trojan Delete
# ====================
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

#################
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###################

# Validate Your IP Address
MYIP=$(wget -qO- ipinfo.io/ip);
clear
NUMBER_OF_CLIENTS=$(grep -qw  "/etc/rare/v2ray/clients.txt")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/etc/trojan/akun.conf" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
CLIENT_NAME=$(grep -E "^### " "/etc/rare/v2ray/clients.txt" | cut -d ' ' -f 2-3 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^### " "/etc/rare/v2ray/clients.txt" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/rare/v2ray/clients.txt" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)

rm /etc/config-url/${user}
uuid="$(cat /etc/v2ray/v2ray/clients.txt | grep -w "$user" | awk '{print $2}')"
cat /etc/v2ray/v2ray/conf/02_VLESS_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/v2ray/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json
mv -f /etc/v2ray/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/v2ray/v2ray/conf/02_VLESS_TCP_inbounds.json
cat /etc/v2ray/v2ray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/v2ray/v2ray/conf/03_VLESS_WS_inbounds_tmp.json
mv -f /etc/v2ray//v2ray/conf/03_VLESS_WS_inbounds_tmp.json /etc/v2ray/v2ray/conf/03_VLESS_WS_inbounds.json
cat /etc/v2ray/v2ray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/v2ray/v2ray/conf/04_trojan_TCP_inbounds_tmp.json
mv -f /etc/v2ray/v2ray/conf/04_trojan_TCP_inbounds_tmp.json /etc/v2ray/v2ray/conf/04_trojan_TCP_inbounds.json		
cat /etc/v2ray/v2ray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/v2ray/v2ray/conf/05_VMess_WS_inbounds_tmp.json
mv -f /etc/v2ray/v2ray/conf/05_VMess_WS_inbounds_tmp.json /etc/v2ray/v2ray/conf/05_VMess_WS_inbounds.json
sed -i "/\b$user\b/d" /etc/v2ray/clients.txt
rm /etc/config-user/${user}
rm /etc/config-url/${uuid}
systemctl restart v2ray.service
service cron restart
clear

echo " Trojan Account Deleted Successfully"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " =========================="
read -p "Press Enter For Back To TRojan Menu/ CTRL+C To Cancel : "
menu-v2ray
