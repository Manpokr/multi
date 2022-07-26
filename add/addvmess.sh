#!/bin/bash
RED='\033[0;31m' 
NC='\033[0m' 
GREEN='\033[0;32m' 
ORANGE='\033[0;33m' 
BLUE='\033[0;34m' 
PURPLE='\033[0;35m' 
CYAN='\033[0;36m' 
LIGHT='\033[0;37m'
                                                                                                                                                                                                                
MYIP=$(wget -qO- ipinfo.io/ip);                                                                                                                                                                                 
echo "Checking VPS"                                                                                                                                                                                             
CEKEXPIRED () {                                                                                                                                                                                                 
    today=$(date -d +1day +%Y-%m-%d)                                                                                                                                                                            
    Exp1=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | grep $MYIP | awk '{print $3}')                                                                                                      
    if [[ $today < $Exp1 ]]; then                                                                                                                                                                               
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"                                                                                                                                                                 
    else                                                                                                                                                                                                        
    echo -e "\e[31mSCRIPT ANDA EXPIRED!\e[0m";                                                                                                                                                                  
    echo -e "\e[31mRenew IP letak tempoh banyak kit okay? hehe syg ktk #\e[0m"                                                                                                                                  
    exit 0                                                                                                                                                                                                      
fi                                                                                                                                                                                                              
}                                                                                                                                                                                                               
IZIN=$(curl -sS https://raw.githubusercontent.com/Manpokr/mon/main/ip | awk '{print $4}' | grep $MYIP)                                                                                                          
if [ $MYIP = $IZIN ]; then                                                                                                                                                                                      
echo -e "\e[32mPermission Accepted...\e[0m"                                                                                                                                                                     
CEKEXPIRED                                                                                                                                                                                                      
else                                                                                                                                                                                                            
echo -e "\e[31mPermission Denied!\e[0m";                                                                                                                                                                        
echo -e "\e[31mDaftar IP dalam github lok sayang okay? mun dah daftar tapi masih juak permission denied refresh dolok website ya hehe. Love you #\e[0m"                                                         
exit 0                                                                                                                                                                                                          
fi         
                                                                                                                                                                                                     
	clear
    echo ""
	read -p "Username  : " user
	if grep -qw "$user" /etc/mon/xray/clients.txt; then
		echo -e ""
		echo -e "User ${RED}$user${NC} already exist"
		echo -e ""
		echo -e "\034[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    read -p "BUG TELCO : " sni
	read -p "Duration (day) : " duration
	uuid=$(cat /proc/sys/kernel/random/uuid)
	exp=$(date -d +${duration}days +%Y-%m-%d)
	expired=$(date -d "${exp}" +"%d %b %Y")
        hariini=$(date -d "0 days" +"%d-%b-%Y")
	domain=$(cat /etc/mon/xray/domain)
	xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	email=${user}
    cat>/etc/mon/xray/tls.json<<EOF
      {
       "v": "2",
       "ps": "${user}",
       "add": "${domain}",
       "port": "${xtls}",
       "id": "${uuid}",
       "aid": "0",
       "scy": "auto",
       "net": "ws",
       "type": "none",
       "host": "${sni}",
       "path": "/xrayvws",
       "tls": "tls",
       "sni": "${sni}"
}
EOF
    vmess_base641=$( base64 -w 0 <<< $vmess_json1)
    vmesslink1="vmess://$(base64 -w 0 /etc/mon/xray/tls.json)"
	echo -e "${user}\t${uuid}\t${exp}" >> /etc/mon/xray/clients.txt

    cat /etc/mon/xray/conf/05_VMess_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${domain}'","email": "'${email}'"}]' > /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/mon/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/mon/xray/conf/05_VMess_WS_inbounds.json

    cat <<EOF >>"/etc/mon/config-user/${user}"
${vmesslink1}
EOF
    cat <<EOF >>"/etc/mon/config-url/${user}"
# =======================================
# XRAY CORE CONFIG MERLIN CLASH ASUS
# telegram: Manternet
# =======================================
proxies:
  - {name: VLess Splice ${user}, server: $domain, port: $xtls, type: vless, flow: xtls-rprx-splice, uuid: $uuid, cipher: auto, tls: true, skip-cert-verify: true, network: tcp, sni: $BUG, udp: true}
  - {name: VLess Direct ${user}, server: $domain, port: $xtls, type: vless, flow: xtls-rprx-direct, uuid: $uuid, cipher: auto, tls: true, skip-cert-verify: true, network: tcp, sni: $BUG, udp: true}
  - {name: VLess WS ${user}, server: $domain, port: $xtls, type: vless, flow: xtls-rprx-direct, uuid: $uuid, cipher: auto, tls: true, skip-cert-verify: true, network: ws, ws-path: /xrayws, ws-headers: {Host: $BUG}, sni: $BUG, udp: true}
  - {name: Trojan ${user}, server: $domain, port: $xtls, type: trojan, password: $uuid, sni: $BUG, skip-cert-verify: true, udp: true}
  - {name: VMess ${user}, server: $domain, port: $xtls, type: vmess, uuid: $uuid, alterId: 0, cipher: auto, tls: true, skip-cert-verify: true, network: ws, ws-path: /xrayvws, ws-headers: {Host: $BUG}, udp: true}
  - {name: VMess SNI ${user}, server: $domain, port: $xtls, type: vmess, uuid: $uuid, alterId: 0, cipher: auto, tls: true, skip-cert-verify: true, network: ws, ws-path: /xrayvws, ws-headers: {Host: $BUG}, sni: $BUG, udp: true}
port: 3333
socks-port: 23456
redir-port: 23457
allow-lan: true
mode: global
log-level: error
external-controller: 192.168.50.1:9990
experimental:
  ignore-resolve-fail: true
external-ui: dashboard
secret: "clash"
profile:
  store-selected: true
ipv6: false
hosts:
  router.asus.com: 192.168.50.1
  services.googleapis.cn: 74.125.193.94
dns:
  enable: true
  ipv6: false
  listen: :23453
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16 
  fake-ip-filter:
    - '*.lan'
    - '*.linksys.com'
    - '*.linksyssmartwifi.com'
    - 'swscan.apple.com'
    - 'mesu.apple.com'
    - '*.msftconnecttest.com'
    - '*.msftncsi.com'
    # === NTP Service ===
    - 'time.*.com'
    - 'time.*.gov'
    - 'time.*.edu.cn'
    - 'time.*.apple.com'
    - 'time1.*.com'
    - 'time2.*.com'
    - 'time3.*.com'
    - 'time4.*.com'
    - 'time5.*.com'
    - 'time6.*.com'
    - 'time7.*.com'
    - 'ntp.*.com'
    - 'ntp.*.com'
    - 'ntp1.*.com'
    - 'ntp2.*.com'
    - 'ntp3.*.com'
    - 'ntp4.*.com'
    - 'ntp5.*.com'
    - 'ntp6.*.com'
    - 'ntp7.*.com'
    - '*.time.edu.cn'
    - '*.ntp.org.cn'
    - '+.pool.ntp.org'
    - 'time1.cloud.tencent.com'
    # === Music Service ===
    ## NetEase
    - '+.music.163.com'
    - '+.126.net'
    ## Baidu
    - 'musicapi.taihe.com'
    - 'music.taihe.com'
    ## Kugou
    - 'songsearch.kugou.com'
    - 'trackercdn.kugou.com'
    ## Kuwo
    - '*.kuwo.cn'
    ## JOOX
    - 'api-jooxtt.sanook.com'
    - 'api.joox.com'
    - 'joox.com'
    ## QQ
    - '+.music.tc.qq.com'
    - 'aqqmusic.tc.qq.com'
    - '+.stream.qqmusic.qq.com'
    ## Xiami
    - '+.xiami.com'
    ## Migu
    - '+.music.migu.cn'
    # === Game Service ===
    ## Nintendo Switch
    - '+.srv.nintendo.net'
    ## Sony PlayStation
    - '+.stun.playstation.net'
    ## Microsoft Xbox
    - 'xbox.*.microsoft.com'
    - '+.xboxlive.com'
    # === Other ===
    ## QQ Quick Login
    - 'localhost.ptlogin2.qq.com'
    ## Golang
    - 'proxy.golang.org'
    ## STUN Server
    - 'stun.*.*'
    - 'stun.*.*.*'
    # === ?? ===
    - '+.qq.com'
    - '+.baidu.com'
    - '+.163.com'
    - '+.126.net'
    - '+.taobao.com'
    - '+.jd.com'
    - '+.tmall.com'
  nameserver:
    - 119.29.29.29
    - 223.5.5.5
    - 180.76.76.76
  fallback:
    - https://doh.dns.sb/dns-query
    - tcp://208.67.222.222:443
    - tls://dns.google
  fallback-filter:
    geoip: true
    ipcidr:
      - 240.0.0.0/4
tproxy: true
tproxy-port: 23458
EOF
	base64Result=$(base64 -w 0 /etc/mon/config-user/${user})
    echo ${base64Result} >"/etc/mon/config-url/${uuid}"
    systemctl restart xray.service
    echo -e "${CYAN}[Info]${NC} xray Start Successfully !"
    sleep 2
    clear

    echo -e "=================================" 
    echo -e "     XRAY USER INFORMATION " 
    echo -e "=================================" 
    echo -e " Username : $user" 
    echo -e " IP/Host  : ${MYIP}" 
    echo -e " Domain   : ${domain}" 
    echo -e " Sni      : ${sni}"
    echo -e " Port     : $xtls"
    echo -e " id       : $uuid"
    echo -e "================================="
    echo -e " VMESS TLS : ${vmesslink1}"
    echo -e "================================="
    echo -e " Created      : $hariini"
    echo -e " Expired date : $expired"
    echo -e "================================="
    echo -e " ScriptMod By Manternet "
    echo ""
