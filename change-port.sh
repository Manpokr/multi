#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
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
echo -e "     [3]  Change Port Wireguard"
echo -e "     [4]  Change Port Trojan"
echo -e "     [5]  Change Port Squid"
echo -e "     [6]  BACK TO MENU"
echo -e "======================================"
echo -e ""
read -p "     Select From Options [1-6 or x] :  " opt
echo -e   ""
case $opt in
1) clear ; port-ssl ; exit ;;
2) clear ; port-ovpn ; exit ;;
3) clear ; port-wg ; exit ;;
4) clear ; port-tr ; exit ;;
5) clear ; port-squid ; exit ;;
6) clear ; menu ; exit ;;
x) exit ;;
*) echo "Boh salah tekan, Sayang kedak Babi" ;;
esac
