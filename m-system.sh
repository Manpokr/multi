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
echo -e " [${CYAN}•1${NC}] Add Host"
echo -e " [${CYAN}•2${NC}] Renew Certv2ray"
echo -e " [${CYAN}•3${NC}] Change Port All Account"
echo -e " [${CYAN}•4${NC}] Backup Data VPS"
echo -e " [${CYAN}•5${NC}] VPS Backup Info"
echo -e " [${CYAN}•6${NC}] Restore Data VPS"
echo -e " [${CYAN}•7${NC}] Limit Bandwith Speed Server"
echo -e " [${CYAN}•8${NC}] Check Usage of Ram"
echo -e " [${CYAN}•9${NC}] Speedtest VPS"
echo -e " [${CYAN}10${NC}] About Script"
echo -e " [${CYAN}11${NC}] Clear Log"
echo -e " [${CYAN}12${NC}] Restart All Service"
echo -e " [${CYAN}13${NC}] Cek Bandwith"
echo -e " [${CYAN}15${NC}] Bbr "
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
1) clear ; add-host ; exit ;;
2) clear ; certv2ray ; exit ;;
3) clear ; port-change ; exit ;;
4) clear ; backup ; exit ;; #set.br
5) clear ; backup-info ; exit ;; #set.br
6) clear ; restore ; exit ;; #set.br
7) clear ; limit-speed ; exit ;; #set.br
8) clear ; ram ; exit ;;
9) clear ; speedtest ; exit ;;
10) clear ; about ; exit ;;
11) clear ; clear-log ; exit ;;
12) clear ; restart ; exit ;;
13) clear ; bw ; exit ;;
14) clear ; resett ; exit ;;
15) clear ; bbr ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "" ; echo "Boh salah tekan" ; sleep 1 ; m-system ;;
esac
