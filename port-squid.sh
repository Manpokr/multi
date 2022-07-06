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
sqd="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | head -n1)"
sqd2="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | tail -n1)"
echo -e "======================================"
echo -e "Name : Change Port Squid"
echo -e ""
echo -e "     [1]  Change Port $sqd"
echo -e "     [2]  Change Port $sqd2"
echo -e "     [x]  Exit"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port Squid: " squid
if [ -z $squid ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $squid)
if [[ -z $cek ]]; then
sed -i "s/$sqd/$squid/g" /etc/squid/squid.conf
sed -i "s/$sqd/$squid/g" /root/log-install.txt
/etc/init.d/squid restart > /dev/null
echo -e "\e[032;1mPort $squid modified successfully\e[0m"
else
echo "Port $squid is used"
fi
;;
2)
read -p "New Port Squid: " squid
if [ -z $squid ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $squid)
if [[ -z $cek ]]; then
sed -i "s/$sqd2/$squid/g" /etc/squid/squid.conf
sed -i "s/$sqd2/$squid/g" /root/log-install.txt
/etc/init.d/squid restart > /dev/null
echo -e "\e[032;1mPort $squid modified successfully\e[0m"
else
echo "Port $squid is used"
fi
;;
x)
exit
menu
;;
*)
echo "Boh salah tekan"
;;
esac
