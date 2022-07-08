#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
LIGHT='\033[0;37m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);

clear
cd
NameUser=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $2}')
cekdata=$(curl -sS https://raw.githubusercontent.com/Manpokr/user-backupv1/main/$NameUser/$NameUser-last-backup | grep 404 | awk '{print $1}' | cut -d: -f1)
echo -e "=================================="
echo -e "            BACKUP INFO           "
echo -e "=================================="
echo -e ""
[[ "$cekdata" = "404" ]] && {
red "Data not found / you never backup"
echo
echo -e "=================================="
echo
read -n 1 -s -r -p "Press any key to back on menu"
m-system
} || {
green "Data found for username $NameUser"
} 
data=$(curl -sS https://raw.githubusercontent.com/Manpokr/user-backupv1/main/$NameUser/$NameUser-last-backup)
echo
echo -e "[ ${green}INFO${NC} ] • Getting info database backup history..."
sleep 2
echo
echo -e "$data"
echo
echo -e "=================================="
echo
read -n 1 -s -r -p "Press any key to back on menu"
m-system
