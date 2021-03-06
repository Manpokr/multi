#!/bin/bash
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                                                                                                                 
NC='\033[0;37m'

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"


clear

# // Autodel
today=$(date -d +1day +%Y-%m-%d)
while read expired
do
	user=$(echo $expired | awk '{print $1}')
	uuid=$(echo $expired | awk '{print $3}')
	exp=$(echo $expired | awk '{print $2}')

	if [[ $exp < $today ]]; then
		rm /etc/config-url/${user}
		cat /etc/mon/xray/conf/02_VLESS_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/mon/xray/conf/02_VLESS_TCP_inbounds_tmp.json
		cat /etc/mon/xray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/xray/conf/03_VLESS_WS_inbounds.json
		cat /etc/mon/xray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_TCP_inbounds.json
		cat /etc/mon/xray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/xray/conf/05_VMess_WS_inbounds.json

                # // Grpc		
                cat /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/xray/conf/04_trojan_gRPC_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/04_trojan_gRPC_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json
                cat /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/06_VLESS_gRPC_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/06_VLESS_gRPC_inbounds_tmp.json /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json
                cat /etc/mon/xray/conf/07_trojan_xtls_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/xray/conf/07_trojan_xtls_inbounds_tmp.json
		mv -f /etc/mon/xray/conf/07_trojan_xtls_inbounds_tmp.json /etc/mon/xray/conf/07_trojan_xtls_inbounds.json


                sed -i "/\b$user\b/d" /etc/xray/clients.txt
		rm /etc/config-user/${user}
		rm /etc/config-url/${uuid}
	fi
done < /etc/xray/clients.txt
service xray restart
