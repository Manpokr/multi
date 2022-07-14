#!/bin/bash
# Xray Auto Setup 
# =========================
RED='\033[0;31m'                                                                                          
GREEN='\033[0;32m'                                                                                                                                                                                 
NC='\033[0;37m'
LIGHT='\033[0;37m'
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"

# // Getting 
MYIP=$(wget -qO- ipinfo.io/ip);
clear

# // Detect public IPv4 address and pre-fill for the user
# // Domain 
domain=$(cat /etc/xray/domain)

# // Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# // Xray Version
version=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | jq -r '.[]|select (.prerelease==false)|.tag_name' | head -1)
		
# // INSTALL XRAY
wget -c -P /etc/mon/xray/ "https://github.com/XTLS/Xray-core/releases/download/${version}/Xray-linux-64.zip"
unzip -o /etc/mon/xray/Xray-linux-64.zip -d /etc/mon/xray 
rm -rf /etc/mon/xray/Xray-linux-64.zip
chmod 655 /etc/mon/xray/xray

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
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "tag": "trojanTCPXTLS",
      "settings": {
        "clients": [],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 31296,
            "xver": 1
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
              "certificateFile": "/etc/xray/xray.crt",
              "keyFile": "/etc/xray/xray.key",
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
    "inbounds": [
        {
            "port": 31304,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "tag": "trojangRPCTCP",
            "settings": {
                "clients": [
                    {
                        "password": "${uuid}",
                        "email": ""
                    }
                ],
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
                    "serviceName": "xraytrojangrpc"
                }
            }
        }
    ]
}
EOF
cat <<EOF >/etc/mon/xray/conf/04_trojan_TCP_inbounds.json
{
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
                "serviceName": "xraygrpc"
            }
        }
    }
]
}
EOF

cat > /etc/systemd/system/vl-xtls.service << EOF
[Unit]
Description=XRay Trojan Service
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
Description=XRay VLess TLS Service
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
Description=XRay VLess TLS Service
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
Description=XRay VLess TLS Service
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
Description=XRay VLess TLS Service
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
Description=XRay VLess TLS Service
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

# // xray
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31304 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

# // xray
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31304 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT

iptables-save >/etc/iptables.rules.v4
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload

# // Starting
systemctl daemon-reload
systemctl restart xray
systemctl enable xray
systemctl restart xray.service
systemctl enable xray.service
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

# // Download
cd /usr/bin
wget -O addxray "https://raw.githubusercontent.com/Manpokr/multi/main/add/addxray.sh"
wget -O cekxray "https://raw.githubusercontent.com/Manpokr/multi/main/cek/cekxray.sh"
wget -O delxray "https://raw.githubusercontent.com/Manpokr/multi/main/del/delxray.sh"
wget -O renewxray "https://raw.githubusercontent.com/Manpokr/multi/main/renew/renewxray.sh"
wget -O trialxray "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialxray.sh"
wget -O menuxray "https://raw.githubusercontent.com/Manpokr/multi/main/menu/menuxray.sh"

chmod +x addxray
chmod +x delxray
chmod +x cekxray
chmod +x renewxray
chmod +x trialxray
chmod +x menuxray
cd

systemctl daemon-reload
systemctl restart nginx
systemctl restart xray
clear
