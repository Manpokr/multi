#!/bin/bash
RED='\033[0;31m' 
NC='\033[0m' 
GREEN='\033[0;32m' 
ORANGE='\033[0;33m' 
BLUE='\033[0;34m' 
PURPLE='\033[0;35m' 
CYAN='\033[0;36m' 
LIGHT='\033[0;37m'

# // CREATED XTLS
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
echo -e "${LIGHT}Please Contact Admin!!!\e[37m" 
rm -f addxray
exit 0
fi
clear

# // Add Trojan
echo ""
        read -p "Username  : " user
	if grep -qw "$user" /etc/mon/xray/clients.txt; then
		echo -e ""
		echo -e "User ${RED}$user${NC} already exist !!!"
		exit 1
	fi
    read -p "SNI (BUG) : " sni
	read -p "Duration (day) : " duration
	uuid=$(cat /proc/sys/kernel/random/uuid)
	exp=$(date -d +${duration}days +%Y-%m-%d)
	expired=$(date -d "${exp}" +"%d %b %Y")
        hariini=$(date -d "0 days" +"%d-%b-%Y")
	domain=$(cat /etc/mon/xray/domain)
	xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	email=${user}@${domain}

        echo -e "${user}\t${uuid}\t${exp}" >> /etc/mon/xray/clients.txt

    cat /etc/mon/xray/conf/04_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_TCP_inbounds.json
       
cat <<EOF >>"/etc/mon/config-user/${user}"
trojan://$uuid@$domain:$xtls?sni=$sni#$user

EOF
 
    systemctl restart xray.service
    echo -e "${CYAN}[Info]${NC} xray Start Successfully !"
    sleep 2
    clear
    echo -e "=================================" 
    echo -e "   XRAY TROJAN USER INFORMATION " 
    echo -e "=================================" 
    echo -e "Username : $user" 
    echo -e "IP/Host  : ${MYIP}" 
    echo -e "Domain   : ${domain}" 
    echo -e "Sni      : ${sni}"
    echo -e "Port     : $xtls"
    echo -e "id       : $uuid"
    echo -e "================================="
    echo -e "Trojan TLS : trojan://$uuid@$domain:$xtls?sni=$sni#$user"
    echo -e "================================="
    echo -e "Created      : $hariini"
    echo -e "Expired date : $expired"
    echo -e "================================="
    echo -e " ScriptMod By Manternet "
    echo ""
