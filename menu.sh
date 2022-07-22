#!/bin/bash
RED='\e[1;31m'
GREEN='\e[0;32m'
NC='\e[0m'

# // Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $MYIP )
if [[ $MYIP = $IZIN ]]; then
echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
echo -e "${NC}${RED}Permission Denied!${NC}";
echo -e "${NC}${LIGHT}Please Contact Admin!!"
rm -f menu
exit 0
fi
clear

#########################

#EXPIRED
expired=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $3}')
echo $expired > /root/expired.txt
today=$(date -d +1day +%Y-%m-%d)
while read expired
do
	exp=$(echo $expired | curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $3}')
	if [[ $exp < $today ]]; then
		Exp2="\033[1;31mExpired\033[0m"
        else
        Exp2=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $3}')
	fi
done < /root/expired.txt
rm /root/expired.txt
Name=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $2}')

# Color Validation
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                        
ORANGE='\033[0;33m'
BLUE='\033[0;34m'                                                                                         
PURPLE='\033[0;35m'
CYAN='\033[0;36m'                                                                                         
NC='\033[0;37m'
LIGHT='\033[0;37m'
yell='\e[33m'
red='\e[31m'
cyan='\e[36m'
bl='\e[36;1m'



# // VPS Information
# // Domain
domain=$(cat /etc/xray/domain)

# // Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi

# // OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

# //Download
# // Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"

# // Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"

# // Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"

# // Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
Sver=$(cat /home/version)
tele=$(cat /home/contact)
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )

# // Ver Xray & V2ray
verxray="$(/etc/mon/xray/xray -version | awk 'NR==1 {print $2}')"                                                                                                                                                                                                    
verv2ray="$(/etc/mon/v2ray/v2ray -version | awk 'NR==1 {print $2}')"   

#Bash
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion
name=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $2}')
exp=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $3}')


clear 
echo -e "                                                                                         "
echo -e "\e[5;33m CPU Model               :\033[m $cname"
echo -e "\e[5;33m CPU Frequency           :\033[m $freq MHz"
echo -e "\e[5;33m Number Of Cores         :\033[m  $cores"
echo -e "\e[5;33m CPU Usage               :\033[m  $cpu_usage"
echo -e "\e[5;33m Operating System        :\033[m  "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`	
echo -e "\e[5;33m Kernel                  :\033[m  `uname -r`"
echo -e "\e[5;33m Total Amount Of RAM     :\033[m  $tram MB"
echo -e "\e[5;33m Used RAM                :\033[m  $red$uram\e[0m MB"
echo -e "\e[5;33m Free RAM                :\033[m  $fram MB"
echo -e "\e[5;33m System Uptime           :\033[m  $uptime "
echo -e "\e[5;33m Isp Name                :\033[m  $ISP"
echo -e "\e[5;33m Domain                  :\033[m  $domain"	
echo -e "\e[5;33m Ip Vps                  :\033[m  $IPVPS"	
echo -e "\e[5;33m City                    :\033[m  $CITY"
echo -e "\e[5;33m Time                    :\033[m  $WKT"
echo -e "\e[5;33m Day                     :\033[m  $DAY"
echo -e "\e[5;33m Date                    :\033[m  $DATE"
echo -e "\e[5;33m Telegram                :\033[m  $tele"
echo -e "\e[5;33m Bash Version            :\033[m ${PURPLE}$versibash${NC}"                                                                                                                                                                                                 
echo -e "\e[5;33m Xray Version            :\033[m  ${PURPLE}$verxray${NC}"                                                                                                                                                                                                 
echo -e "\e[5;33m V2ray Version           :\033[m  ${PURPLE}$verv2ray${NC}"                                                                                                                                                                                                
echo -e "\e[5;33m Script Version          :\033[m  ${BLUE}$Sver${NC}"
echo -e "\e[5;33m Certificate status      :\033[m  \e[33mExpired in ${tlsStatus} days\e[0m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "\e[33m Traffic\e[0m       \e[33mToday      Yesterday     Month   "
echo -e "\e[33m Download\e[0m      $dtoday    $dyest       $dmon   \e[0m"
echo -e "\e[33m Upload\e[0m        $utoday    $uyest       $umon   \e[0m"
echo -e "\e[33m Total\e[0m       \033[0;36m  $ttoday    $tyest       $tmon  \e[0m "
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[30;5;47m                 ⇱ SCRIPT MENU ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e " [${CYAN}•1${NC}] SSH & OpenVPN Menu  [${CYAN}•6${NC}] STATUS Service"                                                                                                                                                                                         
echo -e " [${CYAN}•2${NC}] XRAY Menu           [${CYAN}•7${NC}] VPS Information"                                                                                                                                                                                      
echo -e " [${CYAN}•3${NC}] V2RAY Menu          [${CYAN}•8${NC}] SCRIPTS Info"                                                                                                                                                                                     
echo -e " [${CYAN}•4${NC}] Trojan GFW Menu     [${CYAN}•9${NC}] CLEAR RAM Cache"                                                                                                                                                                                         
echo -e " [${CYAN}•5${NC}] SYSTEM Menu         [${RED}10${NC}] ${RED}REBOOT${NC}"                                                                                                                                                                                     
echo -e   ""
echo -e " [${CYAN}11${NC}] TRIAL Xray"
echo -e " [${CYAN}22${NC}] TRIAL V2ray"
echo -e ""
echo -e   " Press x or [ Ctrl+C ] • To-Exit-Script"
echo -e   ""
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[2;37mClient Name\033[m    : $name"                                                                                                                                                                                                                        
echo -e "\033[2;37mScript Expired\033[m : $exp"                                                                                                                                                                                                                        
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e   ""
read -p " Select menu :  "  opt
echo -e   ""
case $opt in
1) clear ; m-sshovpn ;;
2) clear ; menu-xray ;;
3) clear ; menu-v2ray ;;
4) clear ; menu-trojan ;;
5) clear ; m-system ;;
6) clear ; status ;;
7) clear ; vpsinfo ;;
8) clear ; info-menu ;;
9) clear ; clearcache ;;
10) clear ; reboot ;;
11) clear ; trialxray ;;
22) clear ; trialv2ray ;;
x) exit ;;
esac
