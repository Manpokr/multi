#!/bin/bash
# Xray Auto Setup 
# =========================
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                        
ORANGE='\033[0;33m'
BLUE='\033[0;34m'                                                                                         
PURPLE='\033[0;35m'
CYAN='\033[0;36m'                                                                                         
NC='\033[0;37m'
LIGHT='\033[0;37m'

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"
MYIP=$(wget -qO- ipinfo.io/ip);
clear
domain=$(cat /etc/mon/xray/domain)

apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Kuala_Lumpur
chronyc sourcestats -v
chronyc tracking -v
date

# CertV2ray
sudo pkill -f nginx & wait $!
systemctl stop nginx

sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
domain=$(cat /root/domain)
mkdir /root/.acme.sh

curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
cd /root/

wget -O acme.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install

rm acme.sh
cd .acme.sh

sudo bash acme.sh --upgrade --auto-upgrade
sudo bash acme.sh --set-default-ca --server letsencrypt
sudo bash acme.sh --register-account -m anjang614@gmail.com 
sudo bash acme.sh --issue -d ${domain} --standalone -k ec-256 --force >> /etc/mon/tls/$domain.log
sudo bash acme.sh --installcert -d ${domain} --fullchainpath /etc/mon/xray/xray.crt --keypath /etc/mon/xray/xray.key --ecc

cat /etc/mon/tls/$domain.log
systemctl daemon-reload
systemctl restart nginx

# // Xray Version
#wget -c -P /etc/mon/xray/ "https://github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip"
#unzip -o /etc/mon/xray/Xray-linux-64.zip -d /etc/mon/xray 
#rm -rf /etc/mon/xray/Xray-linux-64.zip
#chmod 655 /etc/mon/xray/xray

# / / Installation Xray Core
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v1.5.5/xray-linux-64.zip"

# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /etc/mon/xray
chmod +x /etc/mon/xray/xray

# // system
rm -rf /etc/systemd/system/xray.service
touch /etc/systemd/system/xray.service

# // XRay boot service
cat <<EOF >/etc/systemd/system/xray.service
[Unit]
Description=Xray - A unified platform for anti-censorship
# Documentation=https://v2ray.com https://guide.v2fly.org
After=network.target nss-lookup.target
Wants=network-online.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
ExecStart=/etc/mon/xray/xray run -confdir /etc/mon/xray/conf        
Restart=on-failure
RestartPreventExitStatus=23
[Install]
WantedBy=multi-user.target
EOF

# // Restart & Add File
systemctl daemon-reload
systemctl enable xray.service
rm -rf /etc/mon/xray/conf/*
rm -rf /etc/mon/xray/config_full.json

# // Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# // Json File
cat <<EOF >/etc/mon/xray/conf/00_log.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  }
}
EOF

cat <<EOF >/etc/mon/xray/conf/10_ipv4_outbounds.json
{
    "outbounds":[
        {
            "protocol":"freedom",
            "settings":{
                "domainStrategy":"UseIPv4"
            },
            "tag":"IPv4-out"
        },
        {
            "protocol":"freedom",
            "settings":{
                "domainStrategy":"UseIPv6"
            },
            "tag":"IPv6-out"
        },
        {
            "protocol":"blackhole",
            "tag":"blackhole-out"
        }
    ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/11_dns.json
{
    "dns": {
        "servers": [
          "localhost"
        ]
  }
}
EOF

cat <<EOF >/etc/mon/xray/conf/02_VLESS_TCP_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "tag": "VLESSTCP",
      "settings": {
        "clients": [],                                                                                   
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 31296,
            "xver": 1
           },
           {
            "alpn": "h1",
            "dest": 31333,
            "xver": 0
           },
           {
            "alpn": "h2",
            "dest": 31302,
            "xver": 0
          },
          {
            "path": "/xrayws",
            "dest": 31297,
            "xver": 1
          },
          {
            "path": "/xrayvws",
            "dest": 31299,
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
        "minVersion": "1.2",
          "alpn": [
            "http/1.1",
            "h2"
          ],
          "certificates": [
            {
              "certificateFile": "/etc/mon/xray/xray.crt",
              "keyFile": "/etc/mon/xray/xray.key",
              "ocspStapling": 3600,
              "usage": "encipherment"
           }
          ]
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/03_VLESS_WS_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31297,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "tag": "VLESSWS",
      "settings": {
        "clients": [],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/xrayws"
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/04_trojan_gRPC_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
    "inbounds": [
        {
            "port": 31304,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "tag": "trojangRPCTCP",
            "settings": {
                "clients": [],
                "fallbacks": [
                    {
                        "dest": "31300"
                    }
                ]
            },
            "streamSettings": {
                "network": "grpc",
                "security": "none",
                "grpcSettings": {
                    "serviceName": "trgrpc"
                }
            }
        }
    ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/04_trojan_TCP_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31296,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "trojanTCP",
      "settings": {
        "clients": [],
        "fallbacks": [
          {
            "dest": "31300"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none",
        "tcpSettings": {
          "acceptProxyProtocol": true
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/05_VMess_WS_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 31299,
      "protocol": "vmess",
      "tag": "VMessWS",
      "settings": {
        "clients": []                                                                 
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/xrayvws"
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
    "inbounds":[
    {
        "port": 31301,
        "listen": "127.0.0.1",
        "protocol": "vless",
        "tag":"VLESSGRPC",
        "settings": {
            "clients": [],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "grpc",
            "grpcSettings": {
                "serviceName": "vlgrpc"
            }
        }
    }
]
}
EOF
cat <<EOF >/etc/mon/xray/conf/07_trojan_TCP_inbounds.json

{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31230,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "trojanXTLS",
      "settings": {
        "clients": [],
        "fallbacks": [
          {
            "dest": "31300"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
             "alpn": [
            "http/1.1",
            "h1"
          ]
        }
      }
    }
  ]
}
EOF

cat> /etc/mon/xray/none.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 8445,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 32
#none
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/xrayvws",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
cat> /etc/mon/xray/vnone.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 8080,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#none
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/xrayws",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END

cat > /etc/systemd/system/vl-xtls.service << EOF
[Unit]
Description=XRay Xtls Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/02_VLESS_TCP_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/vl-wstls.service << EOF
[Unit]
Description=XRay VLess Ws Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/03_VLESS_WS_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/tr-grpc.service << EOF
[Unit]
Description=XRay Trojan Grpc Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/04_trojan_gRPC_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF


cat > /etc/systemd/system/tr-tcp.service << EOF
[Unit]
Description=XRay Trojan TCP Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/04_trojan_TCP_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/vm-ws.service << EOF
[Unit]
Description=XRay Vmess Ws Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/05_VMess_WS_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/vl-grpc.service << EOF
[Unit]
Description=XRay VLess Grpc Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/06_VLESS_gRPC_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/tr-xtls.service << EOF
[Unit]
Description=XRay Trojan xtls Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/conf/07_trojan_TCP_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
cat > /etc/systemd/system/vm-none.service << EOF
[Unit]
Description=XRay vm none Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/none.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/vl-none.service << EOF
[Unit]
Description=XRay Vl None Service
Documentation=https://speedtest.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/xray/xray -config /etc/mon/xray/vnone.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

sleep 1
#echo -e "[\e[32mINFO\e[0m] Installing bbr.."
#wget -q -O /usr/bin/bbr "https://raw.githubusercontent.com/Manpokr/multi/main/bbr.sh"
#chmod +x /usr/bin/bbr
#bbr >/dev/null 2>&1
#rm /usr/bin/bbr >/dev/null 2>&1
#sleep 2

# // xray
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31230 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31304 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8000 -j ACCEPT

# // xray
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31230 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31304 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8000 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT

iptables-save >/etc/iptables.rules.v4
netfilter-persistent save
netfilter-persistent reload

# // Starting
systemctl daemon-reload
systemctl enable xray.service
systemctl restart xray.service
systemctl enable vl-xtls
systemctl restart vl-xtls
systemctl enable vl-wstls
systemctl restart vl-wstls
systemctl enable tr-grpc
systemctl restart tr-grpc
systemctl enable tr-tcp
systemctl restart tr-tcp
systemctl enable vm-ws
systemctl restart vm-ws
systemctl enable vl-grpc
systemctl restart vl-grpc
systemctl enable tr-xtls
systemctl restart tr-xtls
systemctl enable vm-none
systemctl restart vm-none
systemctl enable vl-none
systemctl restart vl-none
# // Download
cd /usr/bin
wget -O addxray "https://raw.githubusercontent.com/Manpokr/multi/main/add/addxray.sh"
wget -O cekxray "https://raw.githubusercontent.com/Manpokr/multi/main/cek/cekxray.sh"
wget -O delxray "https://raw.githubusercontent.com/Manpokr/multi/main/del/delxray.sh"
wget -O renewxray "https://raw.githubusercontent.com/Manpokr/multi/main/renew/renewxray.sh"
wget -O trialxray "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialxray.sh"

wget -O addvless "https://raw.githubusercontent.com/Manpokr/multi/main/add/addvless.sh"
wget -O cekvless "https://raw.githubusercontent.com/Manpokr/multi/main/cek/cekvless.sh"
wget -O delvless "https://raw.githubusercontent.com/Manpokr/multi/main/del/delvless.sh"
wget -O renewvless "https://raw.githubusercontent.com/Manpokr/multi/main/renew/renewvless.sh"
wget -O trialvless "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialvless.sh"

wget -O addvmess "https://raw.githubusercontent.com/Manpokr/multi/main/add/addvmess.sh"
wget -O cekvmess "https://raw.githubusercontent.com/Manpokr/multi/main/cek/cekvmess.sh"
wget -O delvmess "https://raw.githubusercontent.com/Manpokr/multi/main/del/delvmess.sh"
wget -O renewvmess "https://raw.githubusercontent.com/Manpokr/multi/main/renew/renewvmess.sh"
wget -O trialvmess "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialvmess.sh"

wget -O addtrojan "https://raw.githubusercontent.com/Manpokr/multi/main/add/addtrojan.sh"
wget -O cektrojan "https://raw.githubusercontent.com/Manpokr/multi/main/cek/cektrojan.sh"
wget -O deltrojan "https://raw.githubusercontent.com/Manpokr/multi/main/del/deltrojan.sh"
wget -O renewtrojan "https://raw.githubusercontent.com/Manpokr/multi/main/renew/renewtrojan.sh"
wget -O trialtrojan "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialtrojan.sh"


wget -O menu-xray "https://raw.githubusercontent.com/Manpokr/multi/main/menu/menu-xray.sh"

chmod +x addxray
chmod +x delxray
chmod +x cekxray
chmod +x renewxray
chmod +x trialxray

chmod +x addvless
chmod +x delvless
chmod +x cekvless
chmod +x renewvless
chmod +x trialvless

chmod +x addvmess
chmod +x delvmess
chmod +x cekvmess
chmod +x renewvmess
chmod +x trialvmess

chmod +x addtrojan
chmod +x deltrojan
chmod +x cektrojan
chmod +x renewtrojan
chmod +x trialtrojan

chmod +x menu-xray
cd

systemctl daemon-reload
systemctl restart nginx
systemctl restart xray

clear
echo -e " ${RED}XRAY INSTALL DONE ${NC}"
sleep 2
clear

rm -f ins-xray.sh
cp /root/domain /etc/xray
