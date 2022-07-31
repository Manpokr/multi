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
# // Ovpn
ohp_service="$(systemctl show ohp.service --no-page)"
ohpovpn=$(echo "${ohp_service}" | grep 'ActiveState=' | cut -f2 -d=)
openvpn_service="$(systemctl show openvpn.service --no-page)"
oovpn=$(echo "${openvpn_service}" | grep 'ActiveState=' | cut -f2 -d=)

# // Lain²
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

# // V2ray
tls_v2ray_status=$(systemctl status v2ray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)

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

# // Status Service Dropbear
if [[ $dropbear_status == "running" ]]; then 
   status_beruangjatuh="Running [ \033[32mok\033[0m ]"
else
   status_beruangjatuh="Not Running [ \e[31m❌\e[0m ]"
fi

# // Status Service stunnel
if [[ $stunnel_service == "running" ]]; then 
   stunnel_service_status="Running [ \033[32mok\033[0m ]"
else
   stunnel_service_status="Not Running [ \e[31m❌\e[0m ]"
fi

# // xray
# // Status Service xray 
if [[ $xtls_xray_status == "running" ]]; then 
   xray_core="Running [ \033[32mok\033[0m ]"
else
   xray_core="Not Running [ \e[31m❌\e[0m ]"
fi

# // V2ray Core
# // Status Service tls_v2ray_status
if [[ $tls_v2ray_status == "running" ]]; then 
   v2ray_status="Running [ \033[32mok\033[0m ]"
else
   v2ray_status="Not Running [ \e[31m❌\e[0m ]"
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
echo -e "   Stunnel            : $stunnel_service_status"
echo -e "   Squid              : $status_squid"
echo -e "   Fail2Ban           : $status_fail2ban"
echo -e "   Crons              : $status_cron"
echo -e "   Vnstat             : $status_vnstat"
echo -e "   NGINX              : $status_nginx"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"         
echo -e "   XRAY CORE          : $xray_core"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"         
echo -e "   V2RAY CORE         : $v2ray_status"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"         
echo -e "   Trojan GFW         : $trojan_server_status"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "   ScriptMod By Manternet "
