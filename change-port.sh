#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
clear

echo -e ""
echo -e ""
echo -e ""
echo -e "======================================"
echo -e "       Change Port All Service"
echo -e "======================================"
echo -e ""
echo -e "     [1]  Change Port Stunnel4"
echo -e "     [2]  Change Port OpenVPN"
echo -e "     [3]  Change Port Trojan"
echo -e "     [4]  Change Port Squid"
echo -e "     [5]  BACK TO MENU"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1-6 or x] :  " opt
echo -e   ""
case $opt in
1) clear ; port-ssl ; exit ;;
2) clear ; port-ovpn ; exit ;;
3) clear ; port-tr ; exit ;;
4) clear ; port-squid ; exit ;;
5) clear ; menu ; exit ;;
x) exit ;;
*) echo "Boh salah tekan " ;;
esac
