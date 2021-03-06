#!/bin/bash
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                                                                                                                 
NC='\033[0;37m'
LIGHT='\033[0;37m'

# // Getting
domain=$(cat /root/domain)
date

# // Add Folder
mkdir /etc/xray/tls/
mkdir -p /etc/trojan/
touch /etc/trojan/akun.conf

# // install Trojan-Gfw
bash -c "$(wget -O- https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"

# // Cp Json
uuid=$(cat /proc/sys/kernel/random/uuid)
cat <<EOF > /etc/trojan/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 2087,
    "remote_addr": "127.0.0.1",
    "remote_port": 2603,
    "password": [
        "$uuid"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/mon/xray/xray.crt",
        "key": "/etc/mon/xray/xray.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
cat <<EOF> /etc/systemd/system/trojan.service
[Unit]
Description=Trojan
Documentation=https://trojan-gfw.github.io/trojan/

[Service]
Type=simple
ExecStart=/usr/local/bin/trojan -c /etc/trojan/config.json -l /var/log/trojan.log
Type=simple
KillMode=process
Restart=no
RestartSec=42s

[Install]
WantedBy=multi-user.target

EOF

cat <<EOF > /etc/trojan/uuid.txt
$uuid
EOF

# // IpTables
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2087 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2087 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl enable trojan
systemctl restart trojan

cd /usr/bin
wget -O add-tr "https://raw.githubusercontent.com/Manpokr/multi/main/add-tr.sh"
wget -O del-tr "https://raw.githubusercontent.com/Manpokr/multi/main/del-tr.sh"
wget -O cek-tr "https://raw.githubusercontent.com/Manpokr/multi/main/cek-tr.sh"
wget -O renew-tr "https://raw.githubusercontent.com/Manpokr/multi/main/renew-tr.sh"
wget -O menu-trojan "https://raw.githubusercontent.com/Manpokr/multi/main/menu/menu-trojan.sh"
wget -O trialtr "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialtr.sh"

chmod +x add-tr
chmod +x cek-tr
chmod +x del-tr
chmod +x renew-tr
chmod +x trialtr

chmod +x menu-trojan
cd

clear
echo -e " ${RED}TROJAN-GFW INSTALL DONE ${NC}"
sleep 2
clear
cp /root/domain /etc/xray
rm -f ins-trojan.sh

