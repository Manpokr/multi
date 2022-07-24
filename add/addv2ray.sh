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
IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $MYIP ) 
if [[ $MYIP = $IZIN ]]; then 
echo -e "${GREEN}Permission Accepted...${NC}" 
else 
echo -e "${RED}Permission Denied!${NC}"; 
echo -e "${LIGHT}Please Contact Admin!!!\e[37m" 
rm -f addv2ray 
exit 0 
fi
clear

# CREATED XTLS
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

clear
# // Add Xtls
IP=$( curl -s ipinfo.io/ip );
clear
source /var/lib/manpokr/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$(cat /etc/v2ray/domain)
fi

tls="$(cat ~/log-install.txt | grep -w "V2RAY VLESS TLS SPLICE" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/v2ray/clients.txt | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e" Name was already use, please choose another name ${RED}!!!${NC}"
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
email=${user}@${domain}

cat>/etc/v2ray/tls.json<<EOF
{
       "v": "2",
       "ps": "${user}",
       "add": "${dom}",
       "port": "${tls}",
       "id": "${uuid}",
       "aid": "0",
       "scy": "auto",
       "net": "ws",
       "type": "none",
       "host": "${sni}",
       "path": "/v2rayvws",
       "tls": "tls",
       "sni": "${sni}"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmesslink1="vmess://$(base64 -w 0 /etc/v2ray/tls.json)"
echo -e "${user} ${exp} ${uuid}" >> /etc/v2ray/clients.txt

cat /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","add": "'${dom}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json
	mv -f /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds.json

    cat /etc/mon/v2ray/conf/03_VLESS_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/v2ray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/mon/v2ray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/v2ray/conf/03_VLESS_WS_inbounds.json

    cat /etc/mon/v2ray/conf/04_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/v2ray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/v2ray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/v2ray/conf/04_trojan_TCP_inbounds.json

    cat /etc/mon/v2ray/conf/05_VMess_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${dom}'","email": "'${email}'"}]' > /etc/mon/v2ray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/mon/v2ray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/v2ray/conf/05_VMess_WS_inbounds.json

 #   cat /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${dom}'","email": "'${email}'"}]' > /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds_tmp.json
#	mv -f /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds_tmp.json /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds.json

  #  cat /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json_tmp.json
 #	mv -f /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json_tmp.json /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json

  #   cat /etc/mon/v2ray/conf/07_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/v2ray/conf/07_trojan_TCP_inbounds.json_tmp.json
     #   mv -f /etc/mon/v2ray/conf/07_trojan_TCP_inbounds.json_tmp.json /etc/mon/v2ray/conf/07_trojan_TCP_inbounds.json

# // Link Xtls
IP=$( curl -s ipinfo.io/ip )
cat <<EOF >>"/etc/config-user/${user}" 
vless://$uuid@$dom:$xtls?security=tls&encryption=none&type=ws&headerType=$ 
trojan://$uuid@$dom:$xtls?sni=$sni#$user 
vless://$uuid@$dom:$xtls?flow=xtls-rprx-direct&encryption=none&security=x$ 
$vmesslink1
EOF

vl1="vless://$uuid@$dom:$tls?security=tls&encryption=none&type=ws&headerType=none&path=/v2rayws&sni=$sni#$user"
vl2="vless://$uuid@$dom:$8446?mode=gun&security=tls&encryption=none&type=grpc&serviceName=v2vlgrpc&sni=$sni#$user"
vl3="vless://$uuid@$dom:$tls?security=tls&encryption=none&type=tcp&${sni}#${user}"

tr0="trojan://$uuid@$dom:$tls?sni=$sni#$user"
tr1="trojan://$uuid@$dom:8446?mode=gun&security=tls&type=grpc&serviceName=v2trgrpc&sni=${sni}#$user"
vl4="vless://$uuid@$dom:$tls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$sni&type=tcp&headerType=none&host=$sni#$user"
tr2="trojan://$uuid@$dom:$xtls?security=xtls&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=$sni#$user"

systemctl restart v2ray.service
clear
echo -e "================================="
echo -e "          V2RAY CONFIG         "
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "IP/Host        : ${IP}"
echo -e "Domain         : ${domain}"
echo -e "Subdomain      : ${dom}"
echo -e "Sni            : ${sni}"
echo -e "port           : $tls"
echo -e "port Grpc      : 8446"
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
echo -e "Trojan XTLS    : ${tr2}"
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
