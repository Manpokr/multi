#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
clear

# // Add User
uuid=$(cat /etc/trojan/uuid.txt)
source /var/lib/manpokr/ipvps.conf
domain=$(cat /etc/mon/xray/domain)
tr="$(cat ~/log-install.txt | grep -i "Trojan-GFW" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password: " -e user
		user_EXISTS=$(grep -w $user /etc/trojan/akun.conf | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
read -p "Expired (days): " masaaktif
read -p "SNI (BUG)     : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain

# // Cp
sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan/config.json
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan

# // Link
trojanlink="trojan://${user}@${dom}:${tr}?sni=${sni}#${user}"

clear
echo -e "================================="
echo -e "           TROJAN  GFW          "
echo -e "================================="
echo -e "Remarks   : ${user}"
echo -e "IP/Host   : ${MYIP}"
echo -e "Domain    : ${domain}"
echo -e "Subdomain : $dom"
echo -e "Sni/Bug   : ${sni}"
echo -e "Port      : ${tr}"
echo -e "Key       : ${user}"
echo -e "================================="
echo -e "Link TR   : ${trojanlink}"
echo -e "================================="
echo -e "Created   : $hariini"
echo -e "Expired   : $exp"
echo -e "================================="
echo -e "ScriptMod By Manternet"
