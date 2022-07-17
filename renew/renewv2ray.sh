#!/bin/bash
# My Telegram : https://t.me/Manternet
# ==========================================
# // Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
LIGHT='\e[37m'

# ==========================================
# // Getting
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
MYIP=$(curl -sS ipv4.icanhazip.com)
clear

NUMBER_OF_CLIENTS=$(grep -c -E "^" "/etc/v2ray/clients.txt")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo " Client xray renew"
	echo " Press CTRL+C to return"
	echo -e "==============================="
	grep -E "^" "/etc/v2ray/clients.txt" | cut -d ' ' -f 1-2 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
                echo -e "==============================="
			read -rp " Select one client [1]: " CLIENT_NUMBER
		else
                echo -e "==============================="
			read -rp " Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (Days) : " masaaktif
user=$(grep -E "^" "/etc/v2ray/clients.txt" | cut -d ' ' -f 1 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^" "/etc/v2ray/clients.txt" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)

# // Date
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/$user $exp $uuid/$user $exp4 $uuid/g" /etc/v2ray/clients.txt

clear
echo ""
echo "================================"
echo "      Xray Account Renewed  "
echo "================================"
echo "Username  : $user"
echo "Expired   : $exp4"
echo "================================"
echo -e " Script By Manternet\e[37m "
