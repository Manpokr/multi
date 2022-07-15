#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
clear

today=$(date -d +1day +%Y-%m-%d)
while read expired
do
	user=$(echo $expired | awk '{print $1}')
	uuid=$(echo $expired | awk '{print $3}')
	exp=$(echo $expired | awk '{print $2}')

	if [[ $exp < $today ]]; then
		rm /etc/mon/config-url/${user}
		cat /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json
		mv -f /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds.json
		cat /etc/mon/v2ray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/v2ray/conf/03_VLESS_WS_inbounds_tmp.json
		mv -f /etc/mon/v2ray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/v2ray/conf/03_VLESS_WS_inbounds.json
		cat /etc/mon/v2ray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/v2ray/conf/04_trojan_TCP_inbounds_tmp.json
		mv -f /etc/mon/v2ray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/v2ray/conf/04_trojan_TCP_inbounds.json
		cat /etc/mon/v2ray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/v2ray/conf/05_VMess_WS_inbounds_tmp.json
		mv -f /etc/mon/v2ray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/v2ray/conf/05_VMess_WS_inbounds.json
		sed -i "/\b$user\b/d" /etc/mon/v2ray/clients.txt
		rm /etc/config-user/${user}
		
		cat /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds_tmp.json
		mv -f /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds_tmp.json /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json
		cat /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds_tmp.json
		mv -f /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds_tmp.json /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds.json


rm /etc/config-url/${uuid}
	fi
done < /etc/mon/v2ray/clients.txt
systemctl restart v2ray.service
