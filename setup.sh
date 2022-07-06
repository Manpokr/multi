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
if [ -f "/etc/rare/xray/domain" ]; then
echo "Script Already Installed"
exit 0
fi

# // Install
clear
mkdir -p /etc/rare
mkdir -p /etc/rare/xray
mkdir -p /etc/rare/v2ray
mkdir -p /etc/rare/tls
mkdir -p /etc/rare/config-url
mkdir -p /etc/rare/config-user
mkdir -p /etc/rare/xray/conf
mkdir -p /etc/rare/v2ray/conf
mkdir -p /etc/systemd/system/
mkdir -p /var/log/xray/
mkdir -p /var/log/v2ray/
mkdir /var/lib/premium-script;

touch /etc/rare/xray/clients.txt
touch /etc/rare/v2ray/clients.txt
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo "$host" >> /etc/rare/xray/domain
echo "$host" >> /root/domain
echo "2.0 Beta" >> /home/version
echo "Manternet" >> /home/contact
clear

# // Start
secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)

# // Update
apt-get update && apt-get upgrade -y && update-grub -y
clear

# // Install ssh ovpn
wget https://raw.githubusercontent.com/Manpokr/multi/main/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh

# // Install v2ray Trojan
wget https://raw.githubusercontent.com/Manpokr/multi/main/ins-vt.sh && chmod +x ins-vt.sh && screen -S v2ray ./ins-vt.sh

# // Instal Xray
wget https://raw.githubusercontent.com/Manpokr/multi/main/xray-go.sh && chmod +x xray-go.sh && screen -S xray-go ./xray-go.sh

# // Instal V2ray
wget https://raw.githubusercontent.com/Manpokr/multi/main/v2ray-go.sh && chmod +x v2ray-go.sh && screen -S v2ray-go ./v2ray-go.sh

# // Backup
wget https://raw.githubusercontent.com/Manpokr/multi/main/set-br.sh && chmod +x set-br.sh && ./set-br.sh

# Install OHP
wget https://raw.githubusercontent.com/Manpokr/multi/main/ohp.sh && chmod +x ohp.sh && screen -S ohp ./ohp.sh

rm -f /root/ssh-vpn.sh
rm -f /root/ins-vt.sh
rm -f /root/set-br.sh
rm -f /root/xray-go.sh
rm -f /root/v2ray-go.sh
rm -f /root/ohp.sh

cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://ianvpn.xyz

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -O /etc/set.sh "https://raw.githubusercontent.com/Manpokr/multi/main/set.sh"
chmod +x /etc/set.sh
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
echo "   - V2RAY VLESS TLS SPLICE  : 8080" | tee -a log-install.txt
echo "   - V2RAY VLESS TLS DIRECT  : 8080" | tee -a log-install.txt
echo "   - V2RAY VLESS WS TLS      : 8080" | tee -a log-install.txt
echo "   - V2RAY TROJAN TLS        : 8080" | tee -a log-install.txt
echo "   - V2RAY VMESS TLS         : 8080" | tee -a log-install.txt
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
echo "   - Autobackup Data                "  | tee -a log-install.txt
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

