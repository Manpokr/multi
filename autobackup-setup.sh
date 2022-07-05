#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"

clear 
cd /root
rm /root/zippass &> /dev/null
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m     • SETUP AUTO BACKUP •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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
