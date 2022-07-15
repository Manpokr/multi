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
domain=$(cat /etc/xray/domain)
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=1
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null

echo -e "================================"
echo -e "        TRIAL SSH & OVPN"
echo -e "================================"
echo -e "Host           : $MYIP"
echo -e "Domain         : $domain"
echo -e "Username       : $Login "
echo -e "Password       : $Pass"
echo -e "OpenSSH        : 22"
echo -e "Dropbear       : 109, 143"
echo -e "SSL/TLS        : $ssl"
echo -e "Port Squid     : $sqd"
echo -e "Port Squid     : $ovpn"
echo -e "Port Squid     : $ovpn2"
echo -e "Port Squid     : $8087"
echo -e "OVPN   TCP     : http://$domain/client-tcp-$ovpn.ovpn"
echo -e "OVPN UDP       : http://$domain/client-udp-$ovpn2.ovpn"
echo -e "OVPN OHP       : http://$domain/tcp-ohp.ovpn"
echo -e "BadVpn         : 7100-7200-7300"
echo -e "================================"
echo -e "Created        : $masaaktif Hari"
echo -e "Expired        : $exp"
echo -e "================================"
echo -e "Script By Manternet"

