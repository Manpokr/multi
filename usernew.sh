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
clear

# // Add 
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (Days): " masaaktif

domain=$(cat /etc/xray/domain)
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
sqd2="$(cat ~/log-install.txt | grep -w "Squid" | awk '{print $6}' | cut -d: -f2)" #port 8000
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
proxport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | head -n1)"
clear

# // User
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null

# // Menu
echo -e "================================="
echo -e "          SSH & OPENVPN         "
echo -e "================================="
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m         • SSH ACCOUNT •           \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "Username       : $Login "
echo -e "Password       : $Pass"
echo -e "Host           : $domain"
echo -e "OpenSSH        : 22"
echo -e "Dropbear       : 109, 143"
echo -e "SSL/TLS        : $ssl"
echo -e "Port Squid     : $sqd"
echo -e "Port TCP       : $ovpn"
echo -e "Port UDP       : $ovpn2"
echo -e "Port OHP       : 8087"
echo -e "OVPN TCP       : https://$domain/client-tcp-$ovpn.ovpn"
echo -e "OVPN UDP       : https://$domain/client-udp-$ovpn2.ovpn"
echo -e "OVPN OHP       : https://$domain/tcp-ohp.ovpn"
echo -e "BadVpn         : 7100-7200-7300"
echo -e "================================="
echo -e "Jumlah Hari    : $masaaktif Hari"
echo -e "Expired On     : $exp"
echo -e "================================="
echo -e " ScriptMod By Manternet "
