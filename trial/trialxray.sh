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
# Getting
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
rm -f trialxray
exit 0
fi
clear

domain=$(cat /etc/xray/domain)
xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
user=man-`</man/urandom tr -dc X-Z0-9 | head -c4`
exp=1

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
read -p "SNI (BUG)     : " sni
read -p "Subdomain (EXP : manternet.xyz. / Press Enter If Only Using Hosts) : " sub
dom=$sub$domain
email=${user}

cat>/etc/xray/$user-tls.json<<EOF
{
       "v": "2",
       "ps": "${user}",
       "add": "${dom}",
       "port": "${xtls}",
       "id": "${uuid}",
       "aid": "0",
       "scy": "auto",
       "net": "ws",
       "type": "none",
       "host": "${sni}",
       "path": "/xrayvws",
       "tls": "tls",
       "sni": "${sni}"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmesslink1="vmess://$(base64 -w 0 /etc/xray/$user-tls.json)"
echo -e "${user} ${exp} ${uuid}" >> /etc/xray/clients.txt

cat /etc/mon/xray/conf/02_VLESS_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","add": "'${dom}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/mon/xray/conf/02_VLESS_TCP_inbounds.json

    cat /etc/mon/xray/conf/03_VLESS_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/xray/conf/03_VLESS_WS_inbounds.json

    cat /etc/mon/xray/conf/04_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_TCP_inbounds.json

    cat /etc/mon/xray/conf/05_VMess_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${dom}'","email": "'${email}'"}]' > /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/xray/conf/05_VMess_WS_inbounds.json

    cat /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${dom}'","email": "'${email}'"}]' > /etc/mon/xray/conf/06_VLESS_gRPC_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/06_VLESS_gRPC_inbounds_tmp.json /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json

    cat /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json_tmp.json /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json

# // Link Xtls
IP=$( curl -s ipinfo.io/ip )
vl1="vless://$uuid@$dom:$xtls?security=tls&encryption=none&type=ws&headerType=none&path=/xrayws&sni=$sni#$user"
vl2="vless://$uuid@$dom:$8445?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vlgrpc&sni=$sni#$user"
vl3="vless://$uuid@$dom:$xtls?security=tls&encryption=none&type=tcp&${sni}#${user}"

tr0="trojan://$uuid@$dom:$xtls?sni=$sni#$user"
tr1="trojan://$uuid@$dom:8445?mode=gun&security=tls&type=grpc&serviceName=trgrpc&sni=${sni}#$user"
vl4="vless://$uuid@$dom:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$sni&type=tcp&headerType=none&host=$sni#$user"

systemctl restart xray.service
clear
echo -e "================================="
echo -e "        XRAY TRIAL CONFIG        "
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "IP/Host        : ${IP}"
echo -e "Domain         : ${domain}"
echo -e "Subdomain      : ${dom}"
echo -e "Sni            : ${sni}"
echo -e "port           : $xtls"
echo -e "port Grpc      : 8445"
echo -e "id             : ${uuid}"
echo -e "================================="
echo -e "Vless Xtls     : ${vl4}"
echo -e "================================="
echo -e "Vless Ws-TLS   : ${vl1}"
echo -e "================================="
echo -e "Vless Tcp-TLS  : ${vl3}"
echo -e "================================="
echo -e "Trojan TCP     : ${tr0}"
echo -e "================================="
echo -e "Vless GRPC     : ${vl2}"
echo -e "================================="
echo -e "Trojan GRPC    : ${tr1}"
echo -e "================================="
echo -e "Vmess Ws-TLS   : ${vmesslink1}"
echo -e "================================="
echo -e "Created        : $hariini"
echo -e "Expired On     : $exp"
echo -e "================================="
echo -e "Script By Manternet"

