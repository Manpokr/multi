#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

# // Warna
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
clear

# // Cek Scripts
if [ -f "/etc/mon/xray/domain" ]; then
echo "Script Already Installed"
exit 0
fi

# // Domain
apt clean all && apt update -y
echo -e "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "${CYAN} Sila Masukkan Sub Domain (sub.yourdomain.com) $NC"
echo -e "${CYAN} Jika tiada Sila [ Ctrl+C ] • To-Exit $NC"
echo -e "\e[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p " Hostname / Domain: " host

# // Add Folder
clear
mkdir -p /etc/mon
mkdir -p /etc/mon/xray
mkdir -p /etc/mon/tls
mkdir -p /etc/mon/config-url
mkdir -p /etc/mon/config-user
mkdir -p /etc/mon/xray/conf
mkdir -p /etc/systemd/system/
mkdir -p /var/log/xray/
mkdir /var/lib/manpokr;
touch /etc/mon/xray/clients.txt
echo "IP=$host" >> /var/lib/manpokr/ipvps.conf
echo "$host" >> /etc/mon/xray/domain
echo "$host" >> /root/domain
echo "2.0 Beta" >> /home/version
echo "Manternet" >> /home/contact

# // Start
secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)

clear
# // Update
apt-get update -y && apt-get upgrade -y && update-grub -y
clear
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 

# // CloudFlare
wget https://raw.githubusercontent.com/Manpokr/multi/main/cf.sh && chmod +x cf.sh && ./cf.sh
domain=$(cat /root/domain)
echo "IP=$domain" >> /var/lib/manpokr/ipvps.conf

# // Instal Xray
wget https://raw.githubusercontent.com/Manpokr/multi/main/ins-xray.sh && chmod +x ins-xray.sh && screen -S xray ./ins-xray.sh

# // Install v2ray Trojan
#wget https://raw.githubusercontent.com/Manpokr/multi/main/ins-trojan.sh && chmod +x ins-trojan.sh && screen -S trojan ./ins-trojan.sh

# // Install ssh ovpn
wget https://raw.githubusercontent.com/Manpokr/multi/main/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh

# // Backup
wget https://raw.githubusercontent.com/Manpokr/multi/main/set-br.sh && chmod +x set-br.sh && ./set-br.sh

# // Install OHP
wget https://raw.githubusercontent.com/Manpokr/multi/main/ohp.sh && chmod +x ohp.sh && screen -S ohp ./ohp.sh 

rm -f /root/ssh-vpn.sh
rm -f /root/ins-trojan.sh
rm -f /root/set-br.sh
rm -f /root/ins-xray.sh
rm -f /root/ohp.sh
rm -f /root/domain
rm -f /root/cf.sh

restart
history -c
clear

# // Info
sleep 2
echo ""
echo -e "\e[33m━━━━━━━━━[\e[0m \e[32mManternet\e[0m \e[33m]━━━━━━━━━━━\e[0m"
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200"  | tee -a log-install.txt
echo "   - Stunnel4                : 444, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8000 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81, 82"  | tee -a log-install.txt
echo "   - XRAY VLESS XTLS SPLICE  : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS XTLS DIRECT  : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS WS TLS       : 443"  | tee -a log-install.txt
echo "   - XRAY TROJAN TLS         : 443"  | tee -a log-install.txt
echo "   - XRAY VMESS TLS          : 443"  | tee -a log-install.txt
echo "   - Trojan-GFW              : 2087" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                 : Asia/Kuala_Lumpur (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                 : [ON]"  | tee -a log-install.txt
echo "   - DDOS Dflate              : [ON]"  | tee -a log-install.txt
echo "   - IPtables                 : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot              : [OFF]" | tee -a log-install.txt
echo "   - IPv6                     : [OFF]" | tee -a log-install.txt
echo "   - Auto-Remove-Expired      : [ON]"  | tee -a log-install.txt                
echo "   - AutoKill Multi Login User       " | tee -a log-install.txt
echo "   - Auto Delete Expired Account     " | tee -a log-install.txt
echo "   - Fully automatic script          " | tee -a log-install.txt
echo "   - VPS settings                    " | tee -a log-install.txt
echo "   - Admin Control                   " | tee -a log-install.txt
echo "   - Change port                     " | tee -a log-install.txt
echo "   - Restore Data                    " | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo -e "\e[33m━━━━━━━━━[\e[0m \e[32mManternet\e[0m \e[33m]━━━━━━━━━━━\e[0m"
echo ""
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e ""
sleep 3
echo -e ""

# // Reboot
rm -f /root/setup.sh
rm -f /root/.bash_history
reboot

