#!/bin/bash
# By Manternet
#
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
# ==================================================

# // initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# // Domain
domain=$(cat /root/domain)

# // detail nama perusahaan
country=MY
state=Malaysia
locality=Malaysia
organization=Manternet
organizationalunit=Manternet
commonname=Manternet.xyz
email=anjang614@gmail.com

# // simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/Manpokr/multi/main/password"
chmod +x /etc/pam.d/common-password

# // go to root
cd

# // Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# // nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# // Ubah izin akses
chmod +x /etc/rc.local

# // enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# // disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# // update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# // Install Wget And Curl
apt -y install wget curl

# // Install Requirements Tools
apt install ruby -y
apt install python -y
apt install make -y
apt install cmake -y
apt install coreutils -y
apt install rsyslog -y
apt install net-tools -y
apt install zip -y
apt install unzip -y
apt install nano -y
apt install sed -y
apt install gnupg -y
apt install gnupg1 -y
apt install bc -y
apt install jq -y
apt install apt-transport-https -y
apt install build-essential -y
apt install dirmngr -y
apt install libxml-parser-perl -y
apt install neofetch -y
apt install git -y
apt install lsof -y
apt install libsqlite3-dev -y
apt install libz-dev -y
apt install gcc -y
apt install g++ -y
apt install libreadline-dev -y
apt install zlib1g-dev -y
apt install libssl-dev -y
apt install libssl1.0-dev -y
apt install dos2unix -y

# // set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
date

# // set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config


apt-get --reinstall --fix-missing install -y linux-headers-cloud-amd64 bzip2 gzip coreutils wget jq screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl git lsof
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
clear
menu
END
chmod 644 /root/.profile


# // Move
#sed -i 's/aaa/${request_uri}/g' /etc/nginx/conf.d/alone.conf
#sed -i 's/bbb/$content_type/g' /etc/nginx/conf.d/alone.conf
#sed -i 's/ccc/$proxy_add_x_forwarded_for/g' /etc/nginx/conf.d/alone.conf

# // install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/Manpokr/multi/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500


# // setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# // install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# // install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/Manpokr/multi/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# // Setting Vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# // install stunnel
apt install stunnel4 -y

cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 444
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

END

# // make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# // konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# // OpenVPN
wget https://raw.githubusercontent.com/Manpokr/multi/main/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# // install fail2ban
apt install -y dnsutils tcpdump dsniff grepcidr
apt -y install fail2ban

# // Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'


# // banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/Manpokr/multi/main/banner.conf"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# // blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# // download script
cd /usr/bin

# // menu
wget -O menu "https://raw.githubusercontent.com/Manpokr/multi/main/menu.sh"

# // menu ssh-ovpn
wget -O m-sshovpn "https://raw.githubusercontent.com/Manpokr/multi/main/m-sshovpn.sh"
wget -O addssh "https://raw.githubusercontent.com/Manpokr/multi/main/addssh.sh"
wget -O trial "https://raw.githubusercontent.com/Manpokr/multi/main/trial.sh"
wget -O renew "https://raw.githubusercontent.com/Manpokr/multi/main/renew.sh"
wget -O hapus "https://raw.githubusercontent.com/Manpokr/multi/main/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/Manpokr/multi/main/cek.sh"
wget -O member "https://raw.githubusercontent.com/Manpokr/multi/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/Manpokr/multi/main/delete.sh"
wget -O autokill "https://raw.githubusercontent.com/Manpokr/multi/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/Manpokr/multi/main/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/Manpokr/multi/main/tendang.sh"

# // menu system
wget -O m-system "https://raw.githubusercontent.com/Manpokr/multi/main/m-system.sh"
wget -O add-host "https://raw.githubusercontent.com/Manpokr/multi/main/add-host.sh"
wget -O certv2ray "https://raw.githubusercontent.com/Manpokr/multi/main/certv2ray.sh"
wget -O port-change "https://raw.githubusercontent.com/Manpokr/multi/main/port-change.sh"

# // change port
wget -O port-ssl "https://raw.githubusercontent.com/Manpokr/multi/main/port-ssl.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/Manpokr/multi/main/port-ovpn.sh"
wget -O port-tr "https://raw.githubusercontent.com/Manpokr/multi/main/port-tr.sh"
wget -O port-squid "https://raw.githubusercontent.com/Manpokr/multi/main/port-squid.sh"

# // menu system
wget -O ram "https://raw.githubusercontent.com/Manpokr/multi/main/ram.sh"
wget -O speedtest "https://raw.githubusercontent.com/Manpokr/multi/main/speedtest_cli.py"
wget -O vpsinfo "https://raw.githubusercontent.com/Manpokr/multi/main/vpsinfo.sh"
wget -O status "https://raw.githubusercontent.com/Manpokr/multi/main/status.sh"
wget -O about "https://raw.githubusercontent.com/Manpokr/multi/main/about.sh"
wget -O clear-log "https://raw.githubusercontent.com/Manpokr/multi/main/clear-log.sh"
wget -O clearcache "https://raw.githubusercontent.com/Manpokr/multi/main/clearcache.sh"
wget -O restart "https://raw.githubusercontent.com/Manpokr/multi/main/restart.sh"
wget -O bw "https://raw.githubusercontent.com/Manpokr/multi/main/bw.sh"
wget -O resett "https://raw.githubusercontent.com/Manpokr/multi/main/resett.sh"

# // xpired
wget -O xp "https://raw.githubusercontent.com/Manpokr/multi/main/xp.sh"
wget -O xray-xp "https://raw.githubusercontent.com/Manpokr/multi/main/xray-xp.sh"

chmod +x menu
chmod +x m-sshovpn
chmod +x addssh
chmod +x trial
chmod +x renew
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x delete
chmod +x autokill
chmod +x ceklim
chmod +x tendang
chmod +x m-system
chmod +x add-host
chmod +x certv2ray
chmod +x port-change
chmod +x port-ssl
chmod +x port-ovpn
chmod +x port-tr
chmod +x port-squid
chmod +x ram
chmod +x speedtest
chmod +x vpsinfo
chmod +x status
chmod +x about
chmod +x clear-log
chmod +x clearcache
chmod +x restart
chmod +x bw
chmod +x resett
chmod +x xp
chmod +x xray-xp

echo "0 0 * * * root /sbin/hwclock -w   # synchronize hardware & system clock each day at 00:00 am" >> /etc/crontab
echo "0 */12 * * * root /usr/bin/clear-log # clear log every  two hours" >> /etc/crontab
echo "0 */12 * * * root /usr/bin/clearcache  #clear cache every 12hours daily" >> /etc/crontab
echo "0 0 * * * root /usr/bin/delete # delete expired user" >> /etc/crontab
echo "0 0 * * * root /usr/bin/xp # delete expired user" >> /etc/crontab
echo "0 0 * * * root /usr/bin/xray-xp # delete expired user" >> /etc/crontab
echo "0 1 * * * root reboot" >> /etc/crontab

# // remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y

# // finishing
cd
#chown -R www-data:www-data /home/vps/public_html

/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# // finihsing
clear
echo -e "${RED}SSH-VPN INSTALL DONE${NC} "
sleep 2
