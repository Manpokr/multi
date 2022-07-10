#!/bin/bash
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                        
ORANGE='\033[0;33m'
BLUE='\033[0;34m'                                                                                         
PURPLE='\033[0;35m'
CYAN='\033[0;36m'                                                                                         
NC='\033[0;37m'
LIGHT='\033[0;37m'

# // Getting 
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"

function add-user() {
	clear
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m        • ADD XRAY USER •          \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	read -p "Username  : " user
	if grep -qw "$user" /etc/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m already exist"
		echo -e ""
		echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    read -p "BUG TELCO : " BUG
	read -p "Duration (day) : " duration
	uuid=$(cat /proc/sys/kernel/random/uuid)
	exp=$(date -d +${duration}days +%Y-%m-%d)
	expired=$(date -d "${exp}" +"%d %b %Y")
	domain=$(cat /etc/xray/domain)
	xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	email=${user}@${domain}
    cat>/etc/rare/xray/tls.json<<EOF
      {
       "v": "2",
       "ps": "${user}",
       "add": "${BUG}.${domain}",
       "port": "${xtls}",
       "id": "${uuid}",
       "aid": "0",
       "scy": "auto",
       "net": "ws",
       "type": "none",
       "host": "${BUG}",
       "path": "/xrayvws",
       "tls": "tls",
       "sni": "${BUG}"
}
EOF
    vmess_base641=$( base64 -w 0 <<< $vmess_json1)
    vmesslink1="vmess://$(base64 -w 0 /etc/xray/tls.json)"
	echo -e "${user}\t${exp}" >> /etc/xray/clients.txt
    cat /etc/mon/xray/conf/02_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","add": "'${domain}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /etc/mon/xray/conf/02_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/02_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/02_trojan_TCP_inbounds.json

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

    cat <<EOF >>"/etc/mon/config-user/${user}"

vless://$uuid@$domain:$xtls?security=tls&encryption=none&type=ws&headerType=none&path=/xrayws&sni=$BUG#$user
vless://$uuid@$domain:$xtls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=xraygrpc&sni=$BUG#$user
vless://$uuid@$domain:$xtls?security=tls&encryption=none&type=tcp&${BUG}#${user}

trojan://$uuid@$domain:$xtls?sni=$BUG#$user
trojan://$uuid@$domain:$xtls?mode=gun&security=tls&type=grpc&serviceName=xraytrojangrpc&sni=${BUG}#$user
trojan://$uuid@$domain:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$BUG&type=tcp&headerType=none&host=$BUG#$user

${vmesslink1}

EOF

	
    systemctl restart xray.service
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    sleep 2
    clear
echo -e "================================="
echo -e "          XRAY USER INFO         "
echo -e "================================="
echo -e "Remarks        : ${user}"
echo -e "IP/Host        : ${MYIP}"
echo -e "Domain         : ${domain}"
echo -e "Subdomain      : ${dom}"
echo -e "Sni/Bug        : ${BUG}"
echo -e "Port           : $xtls"
echo -e "id             : ${uuid}"
echo -e "=================================""
echo -e "Vless Grpc     : vless://$uuid@$domain:$xtls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=xraygrpc&sni=$BUG#$user"
echo -e "================================="
echo -e "Vless Ws       : vless://$uuid@$domain:$xtls?encryption=none&security=tls&sni=$BUG&type=ws&host=$BUG&path=/xrayws#$user"
echo -e "================================="
echo -e "Vless Tcp Tls  : vless://$uuid@$domain:$xtls?security=tls&encryption=none&type=tcp&${BUG}#${user}"
echo -e "================================="
echo -e "Trojan Tcp     : trojan://$uuid@$domain:$xtls?sni=$BUG#$user"
echo -e "================================="
echo -e "Trojan Grpc    : trojan://$uuid@$domain:${xtls}?mode=gun&security=tls&type=grpc&serviceName=xraytrojangrpc&sni=${BUG}#$user "
echo -e "================================="
echo -e "Trojan Xtls    : trojan://$uuid@$domain:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$BUG&type=tcp&headerType=none&host=$BUG#$user"
echo -e "================================="
echo -e "Vmess          : ${vmesslink1}"
echo -e "================================="
echo -e "Created        : $duration Hari"
echo -e "Expired On     : $expired"
echo -e "================================="
echo -e "ScriptMod By Manternet" 
}

function delete-user() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • DELETE XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""  
	read -p "Username : " user
	echo -e ""
	if ! grep -qw "$user" /etc/xray/clients.txt; then
		echo -e ""
        echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu   
	fi
    rm /etc/config-url/${user}
	uuid="$(cat /etc/xray/clients.txt | grep -w "$user" | awk '{print $2}')"
	cat /etc/mon/xray/conf/02_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/02_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/02_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/02_trojan_TCP_inbounds.json
    cat /etc/mon/xray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/mon/xray/conf/03_VLESS_WS_inbounds.json
    cat /etc/mon/xray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/mon/xray/conf/04_trojan_TCP_inbounds.json		
    cat /etc/mon/xray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/xray/conf/05_VMess_WS_inbounds.json
    sed -i "/\b$user\b/d" /etc/mon/xray/clients.txt
    rm /etc/config-user/${user}
    rm /etc/config-url/${uuid}
	systemctl restart xray.service
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    echo ""
	echo -e "User \e[32m$user\e[0m deleted Successfully !"
	echo ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu 
}

function extend-user() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • EXTEND XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	read -p "Username : " user
	if ! grep -qw "$user" /etc/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu 
	fi
	read -p "Duration (day) : " extend
	uuid=$(cat /etc/xray/clients.txt | grep -w $user | awk '{print $2}')
	exp_old=$(cat /etc/xray/clients.txt | grep -w $user | awk '{print $3}')
	diff=$((($(date -d "${exp_old}" +%s)-$(date +%s))/(86400)))
	duration=$(expr $diff + $extend + 1)
	exp_new=$(date -d +${duration}days +%Y-%m-%d)
	exp=$(date -d "${exp_new}" +"%d %b %Y")
	sed -i "/\b$user\b/d" /etc/xray/clients.txt
	echo -e "$user\t$uuid\t$exp_new" >> /etc/xray/clients.txt
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	echo -e "Username     : $user"
	echo -e "Expired date : $exp"
	echo -e ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu     
}

function user-list() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m        • XRAY USER LIST •         \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo -e  "\e[36mUsername               Exp. Date\e[0m"
    echo ""   
	while read expired
	do
		user=$(echo $expired | awk '{print $1}')
		exp=$(echo $expired | awk '{print $3}')
		exp_date=$(date -d"${exp}" "+%d %b %Y")
		printf "%-17s %2s\n" "$user" "     $exp_date"
	done < /etc/xray/clients.txt
	total=$(wc -l /etc/xray/clients.txt | awk '{print $1}')
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Total accounts: $total"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	echo -e ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu
}

function user-monitor() {
    clear
	echo -n > /tmp/other.txt
	data=($(cat /etc/xray/clients.txt | awk '{print $1}'));
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m      • XRAY USER MONITOR •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	for akun in "${data[@]}"
	do
	if [[ -z "$akun" ]]; then
	akun="tidakada"
	fi
	echo -n > /tmp/ipvmess.txt
	data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
	for ip in "${data2[@]}"
	do
	jum=$(cat /var/log/xray/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
    if [[ "$jum" = "$ip" ]]; then
	echo "$jum" >> /tmp/ipvmess.txt
	else
	echo "$ip" >> /tmp/other.txt
	fi
	jum2=$(cat /tmp/ipvmess.txt)
	sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
	done
	jum=$(cat /tmp/ipvmess.txt)
	if [[ -z "$jum" ]]; then
	echo > /dev/null
	else
	jum2=$(cat /tmp/ipvmess.txt | nl)
	echo "user : $akun";
	echo "$jum2";
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	fi
	rm -rf /tmp/ipvmess.txt
	done
	oth=$(cat /tmp/other.txt | sort | uniq | nl)
	echo "other";
	echo "$oth";
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	rm -rf /tmp/other.txt
	echo -e ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu      
}

function show-config() {
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • XRAY USER CONFIG •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
	read -p "User : " user
	if ! grep -qw "$user" /etc/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m does not exist"
		echo -e ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
    link=$(cat /etc/config-user/${user})
	uuid=$(cat /etc/xray/clients.txt | grep -w "$user" | awk '{print $2}')
	domain=$(cat /etc/xray/domain)
	exp=$(cat /etc/rare/clients.txt | grep -w "$user" | awk '{print $3}')
	exp_date=$(date -d"${exp}" "+%d %b %Y")

	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"      
	echo -e ""
	echo -e " Username      : $user"
	echo -e " Expired date  : $exp_date"
	echo -e " Ip Vps        : $MYIP"
    echo -e " Domain        : $domain"
    echo -e " PORT          : $xtls"
    echo -e " UUID/PASSWORD : $uuid"
	echo -e ""
    echo -e " Link url OPENWRT/V2rayN PC: https://${domain}/s/${uuid}"
	echo -e ""
	echo -e " Link url ASUS Clash: https://${domain}/s/${user}"
    echo -e ""
    echo -e " Config :"
	echo -e " $link"  
	echo -e ""
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu    
}

function change-port() {
	clear
    xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • CHANGE PORT XRAY •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
	echo -e "Change Port XRAY TCP XTLS: $xtls"
	echo -e ""
	read -p "New Port XRAY TCP XTLS: " xtls1
	if [ -z $xtls1 ]; then
	echo "Please Input Port"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    change-port  	
	fi
	cek=$(netstat -nutlp | grep -w $xtls1)
    if [[ -z $cek ]]; then
    sed -i "s/$xtls/$xtls1/g" /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
    sed -i "s/   - XRAY VLESS XTLS SPLICE  : $xtls/   - XRAY VLESS XTLS SPLICE : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VLESS XTLS DIRECT  : $xtls/   - XRAY VLESS XTLS DIRECT  : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VLESS WS TLS       : $xtls/   - XRAY VLESS WS TLS       : $xtls1/g" /root/log-install.txt
	sed -i "s/   - XRAY TROJAN TLS         : $xtls/   - XRAY TROJAN TLS         : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VMESS TLS          : $xtls/   - XRAY VMESS TLS          : $xtls1/g" /root/log-install.txt
    iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $xtls -j ACCEPT
    iptables -D INPUT -m state --state NEW -m udp -p udp --dport $xtls -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $xtls1 -j ACCEPT
    iptables -I INPUT -m state --state NEW -m udp -p udp --dport $xtls1 -j ACCEPT
    iptables-save > /etc/iptables.up.rules
    iptables-restore -t < /etc/iptables.up.rules
    netfilter-persistent save > /dev/null
    netfilter-persistent reload > /dev/null
    systemctl restart xray > /dev/null
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    echo ""
    echo -e "\e[032;1mPort $xtls1 modified Successfully !\e[0m"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu    
    else
    echo "Port $xtls1 is used"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    change-port      
    fi
}

clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m       • XRAY CORE MENU •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""   
echo -e " [\e[36m•1\e[0m] Add XRAY user "
echo -e " [\e[36m•2\e[0m] Delete XRAY user "
echo -e " [\e[36m•3\e[0m] Extend XRAY user "
echo -e " [\e[36m•4\e[0m] View user list "
echo -e " [\e[36m•5\e[0m] Monitor user "
echo -e " [\e[36m•6\e[0m] Show User config "
echo -e " [\e[36m•7\e[0m] Change Port XRAY "
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-user ;;
2) clear ; delete-user ;;
3) clear ; extend-user ;;
4) clear ; user-list ;;
5) clear ; user-monitor ;;
6) clear ; show-config ;;
7) clear ; change-port ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Boh salah tekan, Sayang kedak Babi" ; sleep 1 ; xray-menu ;;
esac
