#!/bin/bash
# // Renew Xray
# ===============

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


# Validate Your IP Address
MYIP=$(wget -qO- ipinfo.io/ip);
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^" "/etc/xray/clients.txt")
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
	grep -E "^" "/etc/xray/clients.txt" | cut -d ' ' -f 1-2 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
                echo -e "==============================="
			read -rp " Select one client [1]: " CLIENT_NUMBER
		else
                echo -e "==============================="
			read -rp " Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (days): " masaaktif
user=$(grep -E "^" "/etc/xray/clients.txt" | cut -d ' ' -f 1 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^" "/etc/xray/clients.txt" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
#sed -i "s/### $user $exp/### $user $exp4/g" /etc/trojan/akun.conf
sed -i "/\b$user\b/d" /etc/xray/clients.txt
echo -e "$user\t$exp3\t$uuid" >> /etc/xray/clients.txt

clear
echo ""
echo " Client Xray Renewed"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp4"
echo " =========================="
echo -e " Script By Manternet\e[37m "
