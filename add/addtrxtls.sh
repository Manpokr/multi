#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
echo "Checking VPS"

# CREATED XTLS
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

clear
# // Input
source /var/lib/Manpokr/ipvps.conf
domain=$(cat /etc/xray/domain)
uuid=$(cat /proc/sys/kernel/random/uuid)

tr="$(cat /etc/xray/trojanxtls.json | grep port | sed 's/"//g' | sed 's/port//g' | sed 's/://g' | sed 's/,//g' | sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/trojanxtls.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
read -p "SNI (bug) : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`
sed -i '/#trojan-xtls$/a\#&# '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "'xtls-rprx-direct'","email": "'""$user""'"' /etc/xray/trojanxtls.json

systemctl restart trojanxtls
IP=$( curl -s ipinfo.io/ip )
trojanlink0="trojan://$uuid@$dom:$tr?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=$sni#$user"
trojanlink1="trojan://$uuid@$dom:$tr?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct-udp443&sni=$sni#$user"
trojanlink2="trojan://$uuid@$dom:$tr?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-splice&sni=$sni#$username"
trojanlink3="trojan://$uuid@$dom:$tr?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-splice-udp443&sni=$sni#$user"

clear
echo -e "================================="
echo -e "       XRAY VLESS TR-XTLS       "
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "IP             : ${MYIP}"
echo -e "Domain         : ${domain}"
echo -e "Subdomain      : ${dom}"
echo -e "Sni            : ${sni}"
echo -e "port TCP       : ${tr}"
echo -e "Password       : ${uuid}"
echo -e "================================="
echo -e "Direct         : ${trojanlink0}"
echo -e "================================="
echo -e "Direct UDP     : ${trojanlink1}"
echo -e "================================="
echo -e "Splice         : ${trojanlink2}"
echo -e "================================="
echo -e "Splice         : ${trojanlink3}"
echo -e "================================="
echo -e "Created        : $hariini"
echo -e "Expired On     : $exp"
