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

echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[30;5;47m                 ⇱ SYSTEM MENU ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e ""
echo -e " [${CYAN}•1${NC}] Panel Domain"
echo -e " [${CYAN}•2${NC}] Change Port All Account"
echo -e " [${CYAN}•3${NC}] Set Auto-Backup Data VPS"
echo -e " [${CYAN}•4${NC}] Backup Data VPS"
echo -e " [${CYAN}•5${NC}] VPS Backup Info"
echo -e " [${CYAN}•6${NC}] Restore Data VPS"
echo -e " [${CYAN}•7${NC}] Webmin Menu"
echo -e " [${CYAN}•8${NC}] Limit Bandwith Speed Server"
echo -e " [${CYAN}•9${NC}] Check Usage of Ram"
echo -e " [${CYAN}10${NC}] Speedtest VPS"
echo -e " [${CYAN}11${NC}] About Script"
echo -e " [${CYAN}12${NC}] Set Auto Reboot"
echo -e " [${CYAN}13${NC}] Clear Log"
echo -e " [${CYAN}14${NC}] Restart All Service"
echo -e " [${CYAN}15${NC}] Change Banner"
echo -e " [${CYAN}16${NC}] Cek Bandwith"
echo -e " [${CYAN}17${NC}] Reset Server"
echo -e " [${CYAN}18${NC}] Kernel Update"
echo -e ""
echo -e " [${RED}•0${NC}] ${RED}BACK TO MENU${NC}"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e   ""
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; m-domain ; exit ;;
2) clear ; port-change ; exit ;;
3) clear ; autobackup-setup ; exit ;; #set.br
4) clear ; backup ; exit ;; #set.br
5) clear ; backup-info ; exit ;; #set.br
6) clear ; restore ; exit ;; #set.br
7) clear ; m-webmin ; exit ;;
8) clear ; limit-speed ; exit ;; #set.br
9) clear ; ram ; exit ;;
10) clear ; speedtest ; exit ;;
11) clear ; about ; exit ;;
12) clear ; auto-reboot ; exit ;;
13) clear ; clear-log ; exit ;;
14) clear ; restart ; exit ;;
15) clear ; nano /etc/issue.net ; exit ;; #ssh-vpn banner.conf
16) clear ; bw ; exit ;;
17) clear ; resett ; exit ;;
18) clear ; kernel-updt ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "" ; echo "Boh salah tekan" ; sleep 1 ; m-system ;;
esac
