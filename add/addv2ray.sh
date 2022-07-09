#!/bin/bash
# My Telegram : https://t.me/manternet
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
clear

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
#domain=$(cat /etc/xray/domain)

domain=$(cat /etc/rare/xray/domain)
uuid=$(cat /proc/sys/kernel/random/uuid)
xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /etc/rare/xray/clients.txt | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
email=${user}@${domain}
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
read -p "SNI (bug) : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`

# // Add
echo -e "${user}\t${uuid}\t${exp}" >> /etc/rare/xray/clients.txt
cat /etc/rare/xray/conf/04_trojan_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/rare/xray/conf/04_trojan_gRPC_inbounds.json_tmp.json
mv -f /etc/rare/xray/conf/04_trojan_gRPC_inbounds.json_tmp.json /etc/rare/xray/conf/04_trojan_gRPC_inbounds.json

# // Link
trojanlink1="trojan://$uuid@$dom:${xtls}?mode=gun&security=tls&type=grpc&serviceName=xraytrojangrpc&sni=${sni}#${user}"
systemctl restart xray.service
service restart cron
clear
echo -e ""
echo -e "================================="
echo -e "        XRAY TROJAN GRPC        "
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "IP             : ${MYIP}"
echo -e "Domain         : ${domain}"
echo -e "Subdomain      : ${dom}"
echo -e "Sni            : ${sni}"
echo -e "port TCP       : ${xtls}"
echo -e "Password       : ${uuid}"
echo -e "================================="
echo -e "Link TR        : ${trojanlink1}"
echo -e "================================="
echo -e "Created        : $hariini"
echo -e "Expired On     : $exp"
echo -e "================================="
echo -e "Script By Manternet"
