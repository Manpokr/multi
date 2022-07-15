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
echo -e "\033[30;5;47m                 ⇱ TROJAN GFW MENU ⇲              \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo ""  
echo -e " [${CYAN}•1${NC}] Create Trojan Account"
echo -e " [${CYAN}•2${NC}] Deleting Trojan Account"
echo -e " [${CYAN}•3${NC}] Renew Trojan Account"
echo -e " [${CYAN}•4${NC}] Check User Login Trojan"
echo -e ""
echo -e " [${RED}•0${NC}] ${RED}BACK TO MENU${NC}"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo ""
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-tr ;;
2) clear ; del-tr ;;
3) clear ; renew-tr ;;
4) clear ; cek-tr ;;
0) clear ; menu ;;
x) exit ;;
*) echo "Boh salah tekan" ; sleep 1 ; m-trojan ;;
esac
