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
# // Add Xtls
domain=$(cat /etc/xray/domain)
xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/clients.txt | wc -l)

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
email=${user}@${domain}

cat>/etc/xray/tls.json<<EOF
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
vmesslink1="vmess://$(base64 -w 0 /etc/xray/tls.json)"
echo -e "${user}\t${exp}" >> /etc/xray/clients.txt

cat /etc/mon/xray/conf/02_VLESS_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","add": "'${domain}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/mon/xray/conf/02_VLESS_TCP_inbounds.json

    cat /etc/mon/xray/conf/03_VLESS_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/xray/conf/03_VLESS_WS_inbounds.json

    cat /etc/mon/xray/conf/04_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_TCP_inbounds.json

    cat /etc/mon/xray/conf/05_VMess_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${domain}'","email": "'${email}'"}]' > /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/xray/conf/05_VMess_WS_inbounds.json

    cat /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${domain}'","email": "'${email}'"}]' > /etc/mon/xray/conf/06_VLESS_gRPC_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/06_VLESS_gRPC_inbounds_tmp.json /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json

    cat /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json_tmp.json /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json

# // Add
echo -e "${user}\t${exp}" >> /etc/xray/clients.txt

# // Link Xtls
IP=$( curl -s ipinfo.io/ip )
vl0="vless://$uuid@$dom:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$sni&type=tcp&headerType=none&host=$sni#$user"
vl1="vless://$uuid@$dom:$xtls?security=tls&encryption=none&type=ws&headerType=none&path=/xrayws&sni=$sni#$user"
vl2="vless://$uuid@$dom:$8445?mode=gun&security=tls&encryption=none&type=grpc&serviceName=xraygrpc&sni=$sni#$user"
vl3="vless://$uuid@$dom:$xtls?security=tls&encryption=none&type=tcp&${sni}#${user}"

tr0=""trojan://$uuid@$dom:$xtls?sni=$sni#$user"
tr1="trojan://$uuid@$dom:8445?mode=gun&security=tls&type=grpc&serviceName=trgrpc&sni=${sni}#$user"
${vmesslink1}

systemctl restart xray.service
clear
echo -e "================================="
echo -e "         XRAY VLESS XTLS         "
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "IP/Host        : ${IP}"
echo -e "Domain         : ${domain}"
echo -e "Subdomain      : ${dom}"
echo -e "Sni            : ${sni}"
echo -e "port           : $xtls"
echo -e "port Grpc      : $8445"
echo -e "id             : ${uuid}"
echo -e "================================="
echo -e "Vless Tcp-XTLS : ${vl0}"
echo -e "================================="
echo -e "Vless Ws-TLS   : ${vl1}"
echo -e "================================="
echo -e "Vless Tcp-TLS  : ${vl3}"
echo -e "================================="
echo -e "Trojan TCP     : ${tr0}"
echo -e "================================="
echo -e "Vmess Ws-TLS   : ${vmesslink1}"
echo -e "================================="
echo -e "Vless GRPC     : ${vl2}"
echo -e "================================="
echo -e "Trojan GRPC    : ${tr1}"
echo -e "================================="
echo -e "Created        : $hariini"
echo -e "Expired On     : $exp"
echo -e "=========================="
echo -e "Script By Manternet"
