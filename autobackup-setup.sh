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
cd /root
rm /root/zippass &> /dev/null
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[30;5;47m           ⇱ SETUP AUTO BACKUP ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "" 
echo -e "Create password Backup ZIP File"
echo -e "" 
read -e -p "Enter password : " password
echo -e "password=$password" >> /root/zippass
echo "0 5 * * * root /usr/bin/autobackup # Autobackup VPS 5AM Every day" >> /etc/crontab
sleep 2
echo -e "" 
echo -e "[\e[32mINFO\e[0m] SETUP AUTO BACKUP 5AM EVERY DAY Successfully !"
# source /root/zippass
# password=$password
echo -e "" 
echo -e "[\e[32mINFO\e[0m] Processing AUTO BACKUP"
sleep 2
autobackup
echo -e "Link location /root/linkbackup"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
m-system
