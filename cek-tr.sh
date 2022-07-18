#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
LIGHT='\033[0;37m'

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
clear

data=( `cat /var/log/trojan.log | grep -w 'authenticated as' | awk '{print $7}' | sort | uniq`);
echo "---------------------------------";
echo "-----=[ Trojan User Login ]=-----";
echo "---------------------------------";
echo -e ""
for akun in "${data[@]}"
do
data2=( `lsof -n | grep -i ESTABLISHED | grep trojan | awk '{print $9}' | cut -d':' -f2 | grep -w 445 | cut -d- -f2 | grep -v '>127.0.0.1' | sort | uniq | cut -d'>' -f2`);
echo -n > /tmp/iptrojan.txt
for ip in "${data2[@]}"
do
jum=$(cat /var/log/trojan.log | grep -w $akun | awk '{print $4}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
echo "$jum" > /tmp/iptrojan.txt
fi
done
jum2=$(cat /tmp/iptrojan.txt | nl)
echo "user : $akun";
echo "$jum2";
done
echo "-------------------------------"
echo "ScriptMod By Manternet"
read -n 1 -s -r -p "Press any key to back on menu"
m-trojan
