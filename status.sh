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
MYIP=$(wget -qO- icanhazip.com);
echo "Checking VPS"

# // Chek Status 
ohp_service="$(systemctl show ohp.service --no-page)"
ohpovpn=$(echo "${ohp_service}" | grep 'ActiveState=' | cut -f2 -d=)
openvpn_service="$(systemctl show openvpn.service --no-page)"
oovpn=$(echo "${openvpn_service}" | grep 'ActiveState=' | cut -f2 -d=)
#status_openvp=$(/etc/init.d/openvpn status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
#status_ss_tls="$(systemctl show shadowsocks-libev-server@tls.service --no-page)"
#ss_tls=$(echo "${status_ss_tls}" | grep 'ActiveState=' | cut -f2 -d=)
#sssotl=$(systemctl status shadowsocks-libev-server@*-tls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1) 
#status_ss_http="$(systemctl show shadowsocks-libev-server@http.service --no-page)"
#ss_http=$(echo "${status_ss_http}" | grep 'ActiveState=' | cut -f2 -d=)
#sssohtt=$(systemctl status shadowsocks-libev-server@*-http | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
#status="$(systemctl show shadowsocks-libev.service --no-page)"
#status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
#ssr_status=$(systemctl status ssrmu | grep Active | awk '{print $2}' | cut -d "(" -f2 | cut -d ")" -f1)

dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
stunnel_service=$(/etc/init.d/stunnel4 status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
squid_service=$(/etc/init.d/squid status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vnstat_service=$(/etc/init.d/vnstat status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx_status=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(/etc/init.d/cron status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# // Trojan
trojan_server=$(systemctl status trojan | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# // xray
xtls_xray_status=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
xtls_xray=$(systemctl status vl-xtls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vlws_xray=$(systemctl status vl-wstls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trgrpc_xray=$(systemctl status tr-grpc | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trtcp_xray=$(systemctl status tr-tcp | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vmws_xray=$(systemctl status vm-ws | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vlgrpc_xray=$(systemctl status vl-grpc | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trxtls_xray=$(systemctl status tr-xtls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# // V2ray
tls_v2ray_status=$(systemctl status v2ray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
xtls_v2ray=$(systemctl status v2-vl-xtls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vlws_ v2ray=$(systemctl status v2-vl-ws | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trgrpc_v2ray=$(systemctl status v2-tr-grpc | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trtcp_v2ray=$(systemctl status v2-tr-tcp | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vmws_v2ray=$(systemctl status v2-vm-ws | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
vlgrpc_v2ray=$(systemctl status v2-vl-grpc | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
trxtls_v2ray=$(systemctl status v2-tr-xtls | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

#wg="$(systemctl show wg-quick@wg0.service --no-page)"
#swg=$(echo "${wg}" | grep 'ActiveState=' | cut -f2 -d=)                                     

#strgo=$(echo "${trgo}" | grep 'ActiveState=' | cut -f2 -d=)  
#sswg=$(systemctl status wg-quick@wg0 | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

# // Color Validation
yell='\e[33m'
RED='\033[0;31m'
NC='\e[0m'
GREEN='\e[31m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
clear

# // Status Service OpenVPN
if [[ $oovpn == "active" ]]; then
  status_openvpn="Running [ \033[32mok\033[0m ]"
else
  status_openvpn="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service OHP
if [[ $ohpovpn == "active" ]]; then
  status_OHPovpn="Running [ \033[32mok\033[0m ]"
else
  status_OHPovpn="Not Running [ \e[31m❌\e[0m ]"
fi

# Status Service  SSH 
if [[ $ssh_service == "running" ]]; then 
   status_ssh="Running [ \033[32mok\033[0m ]"
else
   status_ssh="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service  Squid 
if [[ $squid_service == "running" ]]; then 
   status_squid="Running [ \033[32mok\033[0m ]"
else
   status_squid="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service  VNSTAT 
if [[ $vnstat_service == "running" ]]; then 
   status_vnstat="Running [ \033[32mok\033[0m ]"
else
   status_vnstat="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service NGINX
if [[ $nginx_status == "running" ]]; then 
   status_nginx="Running [ \033[32mok\033[0m ]"
else
   status_nginx="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service  Crons 
if [[ $cron_service == "running" ]]; then 
   status_cron="Running [ \033[32mok\033[0m ]"
else
   status_cron="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service  Fail2ban 
if [[ $fail2ban_service == "running" ]]; then 
   status_fail2ban="Running [ \033[32mok\033[0m ]"
else
   status_fail2ban="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service XTLS XRAY
if [[ $xtls_xray_status == "running" ]]; then 
   status_xtls_xray="Running [ \033[32mok\033[0m ]"
else
   status_xtls_xray="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service TLS V2RAY
if [[ $tls_v2ray_status == "running" ]]; then 
   status_tls_v2ray="Running [ \033[32mok\033[0m ]"
else
   status_tls_v2ray="Not Running [ \e[31m❌\e[0m ]"
fi

# // ShadowsocksR Status
#if [[ $ssr_status == "active" ]] ; then
#  status_ssr="Running [ \033[32mok\033[0m ]"
#else
#  status_ssr="Not Running [ \e[31m❌\e[0m ]"
#fi

# // Sodosok
#if [[ $status_text == "active" ]] ; then
#  status_sodosok="Running [ \033[32mok\033[0m ]"
#else
#  status_sodosok="Not Running [ \e[31m❌\e[0m ]"
#fi

# // Status Service Trojan
if [[ $trojan_server == "running" ]]; then 
   status_virus_trojan="Running [ \033[32mok\033[0m ]"
else
   status_virus_trojan="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service Wireguard
#if [[ $swg == "active" ]]; then
#  status_wg="Running [ \033[32mok\033[0m ]"
#else
#  status_wg="Not Running [ \e[31m❌\e[0m ]"
#fi

# // Status Service Dropbear
if [[ $dropbear_status == "running" ]]; then 
   status_beruangjatuh="Running [ \033[32mok\033[0m ]"
else
   status_beruangjatuh="Not Running [ \e[31m❌\e[0m ]"
fi


# // xray
# // Status Service xray 
if [[ $xtls_xray_status == "running" ]]; then 
   xray_core="Running [ \033[32mok\033[0m ]"
else
   xray_core="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service xtls
if [[ $xtls_xray == "running" ]]; then 
   xtls_xray="Running [ \033[32mok\033[0m ]"
else
   xtls_xray="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vlws_xray
if [[ $vlws_xray == "running" ]]; then 
   vlws_xray_status="Running [ \033[32mok\033[0m ]"
else
   vlws_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service trgrpc_xray
if [[ $trgrpc_xray == "running" ]]; then 
   trgrpc_xray_status="Running [ \033[32mok\033[0m ]"
else
   trgrpc_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service trtcp_xray
if [[ $trtcp_xray == "running" ]]; then 
   trtcp_xray_status="Running [ \033[32mok\033[0m ]"
else
   trtcp_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vmws_xray
if [[ $vmws_xray == "running" ]]; then 
   vmws_xray_status="Running [ \033[32mok\033[0m ]"
else
   vmws_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vlgrpc_xray
if [[ $vlgrpc_xray == "running" ]]; then 
   vlgrpc_xray_status="Running [ \033[32mok\033[0m ]"
else
   vlgrpc_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service trxtls_xray
if [[ $trxtls_xray == "running" ]]; then 
   trxtls_xray_status="Running [ \033[32mok\033[0m ]"
else
   trxtls_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // V2ray Core
# // Status Service tls_v2ray_status
if [[ $tls_v2ray_status == "running" ]]; then 
   v2ray_status="Running [ \033[32mok\033[0m ]"
else
   v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vlgrpc_xray
if [[ $vlgrpc_xray == "running" ]]; then 
   vlgrpc_xray_status="Running [ \033[32mok\033[0m ]"
else
   vlgrpc_xray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service xtls_v2ray
if [[ $xtls_v2ray == "running" ]]; then 
   xtls_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   xtls_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vlws_v2ray
if [[ $vlws_v2ray == "running" ]]; then 
   vlws_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   vlws_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service trgrpc_v2ray
if [[ $trgrpc_v2ray == "running" ]]; then 
   trgrpc_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   trgrpc_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service trtcp_v2ray
if [[ $trtcp_v2ray == "running" ]]; then 
   trtcp_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   trtcp_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vmws_v2ray
if [[ $vmws_v2ray == "running" ]]; then 
   vmws_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   vmws_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service vlgrpc_v2ray
if [[ $vlgrpc_v2ray == "running" ]]; then 
   vlgrpc_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   vlgrpc_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service trxtls_v2ray
if [[ $trxtls_v2ray == "running" ]]; then 
   trxtls_v2ray_status="Running [ \033[32mok\033[0m ]"
else
   trxtls_v2ray_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // Trojan
# // Status Service trojan_server
if [[ $trojan_server == "running" ]]; then 
   trojan_server_status="Running [ \033[32mok\033[0m ]"
else
   trojan_server_status="Not Running [ \e[31m❌\e[0m ]"
fi


clear
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[30;5;47m                 ⇱ STATUS-SERVICE ⇲               \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"         
echo -e "   "
echo -e "   SSH / Tun          : $status_ssh"
echo -e "   OpenVPN            : $status_openvpn"
echo -e "   OHP                : $status_OHPovpn"
echo -e "   Dropbear           : $status_beruangjatuh"
echo -e "   Stunnel            : $status_stunnel"
echo -e "   Squid              : $status_squid"
echo -e "   Fail2Ban           : $status_fail2ban"
echo -e "   Crons              : $status_cron"
echo -e "   Vnstat             : $status_vnstat"
echo -e "   NGINX              : $status_nginx"
echo -e "   XRAY CORE          : $status_xtls_xray"
echo -e "   XRAY Vmess-Ws-Tls  : $status_xtls_xray"
echo -e "   XRAY Vless-Ws-Tls  : $status_xtls_xray"
echo -e "   XRAY Vless-Xtls    : $status_xtls_xray"
echo -e "   XRAY Vless-Grpc    : $status_xtls_xray"
echo -e "   XRAY Trojan-Tcp    : $status_xtls_xray"
echo -e "   XRAY Trojan-Grpc   : $status_xtls_xray"
echo -e "   V2RAY CORE         : $status_tls_v2ray"
echo -e "   V2RAY Vmess-Ws-Tls : $status_tls_v2ray"
echo -e "   V2RAY Vless-Ws-Tls : $status_tls_v2ray"
echo -e "   V2RAY Vless-Xtls   : $status_tls_v2ray"
echo -e "   V2RAY Vless-Grpc   : $status_tls_v2ray"
echo -e "   V2RAY Trojan-Tcp   : $status_tls_v2ray"
echo -e "   V2RAY Trojan-Grpc  : $status_tls_v2ray"
echo -e "   Trojan GFW         : $status_virus_trojan"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "   ScriptMod By Manternet "
