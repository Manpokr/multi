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

#data=( `cat /etc/shadowsocks-libev/akun.conf | grep '^###' | cut -d ' ' -f 2`);
#now=`date +"%Y-%m-%d"`
#for user in "${data[@]}"
#do
#exp=$(grep -w "^### $user" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f 3)
#d1=$(date -d "$exp" +%s)
#d2=$(date -d "$now" +%s)
#exp2=$(( (d1 - d2) / 86400 ))
#if [[ "$exp2" = "0" ]]; then
#sed -i "/^### $user $exp/,/^port_http/d" "/etc/shadowsocks-libev/akun.conf"
#systemctl disable shadowsocks-libev-server@$user-tls.service
#systemctl disable shadowsocks-libev-server@$user-http.service
#systemctl stop shadowsocks-libev-server@$user-tls.service
#systemctl stop shadowsocks-libev-server@$user-http.service
#rm -f "/etc/rare/config-url/ss-${user}"
#rm -f "/etc/shadowsocks-libev/$user-tls.json"
#rm -f "/etc/shadowsocks-libev/$user-http.json"
#fi
#done

#data=( `cat /usr/local/shadowsocksr/akun.conf | grep '^###' | cut -d ' ' -f 2`);
#now=`date +"%Y-%m-%d"`
#for user in "${data[@]}"
#do
#exp=$(grep -w "^### $user" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f 3)
#d1=$(date -d "$exp" +%s)
#d2=$(date -d "$now" +%s)
#exp2=$(( (d1 - d2) / 86400 ))
#if [[ "$exp2" = "0" ]]; then
#rm -f "/etc/rare/config-url/ssr-${user}"
#sed -i "/^### $user $exp/d" "/usr/local/shadowsocksr/akun.conf"
#cd /usr/local/shadowsocksr
#match_del=$(python mujson_mgr.py -d -u "${user}"|grep -w "delete user")
#cd
#fi
#done

#/etc/init.d/ssrmu restart
#data=( `cat /etc/wireguard/wg0.conf | grep '^### Client' | cut -d ' ' -f 3`);
#now=`date +"%Y-%m-%d"`
#for user in "${data[@]}"
#do
#exp=$(grep -w "^### Client $user" "/etc/wireguard/wg0.conf" | cut -d ' ' -f 4)
#d1=$(date -d "$exp" +%s)
#d2=$(date -d "$now" +%s)
#exp2=$(( (d1 - d2) / 86400 ))
#if [[ "$exp2" = "0" ]]; then
#sed -i "/^### Client $user $exp/,/^AllowedIPs/d" /etc/wireguard/wg0.conf
#rm -f "/usr/share/nginx/html/$user.conf"
#fi
#done
#systemctl restart wg-quick@wg0

data=( `cat /etc/trojan/akun.conf | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/trojan/akun.conf" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/etc/trojan/akun.conf"
sed -i '/^,"'"$user"'"$/d' /etc/trojan/config.json
fi
done
systemctl restart trojan
