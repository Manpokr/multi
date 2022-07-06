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
echo -e "\033[30;5;47m         ⇱ CERT / RENEW DOMAIN ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "" 
echo "Please Input Your Pointing Domain In Cloudflare "
read -rp "Domain/Host: " -e host
rm /etc/rare/xray/domain
echo "$host" >> /etc/rare/xray/domain
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo -e "" 
#Update Sertificate SSL
echo "Automatical Update Your Sertificate SSL"
sleep 3
echo Starting Update SSL Sertificate
sleep 0.5
source /var/lib/premium-script/ipvps.conf
domain=$IP
systemctl stop nginx
systemctl stop xray
systemctl stop xray.service
systemctl stop trojan
systemctl stop trojan.service
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/rare/xray/xray.crt --keypath /etc/rare/xray/xray.key --ecc
systemctl daemon-reload
systemctl restart nginx
systemctl daemon-reload
systemctl restart trojan
systemctl restart trojan.service
systemctl restart xray
systemctl restart xray.service
echo ""
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
m-domain
