#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"

clear

today=$(date -d +1day +%Y-%m-%d)

while read expired
do
	user=$(echo $expired | awk '{print $1}')
	uuid=$(echo $expired | awk '{print $2}')
	exp=$(echo $expired | awk '{print $3}')

	if [[ $exp < $today ]]; then
		rm /etc/rare/config-url/${user}
		cat /etc/rare/v2ray/conf/02_VLESS_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json
		mv -f /etc/rare/v2ray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/rare/v2ray/conf/02_VLESS_TCP_inbounds.json
		cat /etc/rare/v2ray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/v2ray/conf/03_VLESS_WS_inbounds_tmp.json
		mv -f /etc/rare/v2ray/conf/03_VLESS_WS_inbounds_tmp.json /etc/rare/v2ray/conf/03_VLESS_WS_inbounds.json
		cat /etc/rare/v2ray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/rare/v2ray/conf/04_trojan_TCP_inbounds_tmp.json
		mv -f /etc/rare/v2ray/conf/04_trojan_TCP_inbounds_tmp.json /etc/rare/v2ray/conf/04_trojan_TCP_inbounds.json
		cat /etc/rare/v2ray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/v2ray/conf/05_VMess_WS_inbounds_tmp.json
		mv -f /etc/rare/v2ray/conf/05_VMess_WS_inbounds_tmp.json /etc/rare/v2ray/conf/05_VMess_WS_inbounds.json
		sed -i "/\b$user\b/d" /etc/rare/v2ray/clients.txt
		rm /etc/rare/config-user/${user}
		rm /etc/rare/config-url/${uuid}
	fi
done < /etc/rare/v2ray/clients.txt
systemctl restart v2ray.service
