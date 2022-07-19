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
echo -e "\033[30;5;47m                 ⇱ DOMAIN MENU ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "" 
echo -e " [${CYAN}•1${NC}] CHANGE DOMAIN VPS"
echo -e " [${CYAN}•2${NC}] Add ID Cloudflare"
echo -e " [${CYAN}•3${NC}] ADD SUB DOMAIN CLOUDFLARE"
echo -e " [${CYAN}•4${NC}] Pointing BUG"
echo -e " [${CYAN}•5${NC}] Renew Certificate DOMAIN"
echo -e ""
echo -e " [${RED}•x${NC}] ${RED}MENU${NC}"
echo -e   ""
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[37m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-host ;;
2) clear ; cff ;;
3) clear ; cfd ;;
4) clear ; cfh ;;
5) clear ; certv2ray ;;
x) clear ; menu ;;
*) echo "Boh salah tekan " ; sleep 1 ; m-domain ;;
esac
