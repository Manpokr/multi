#!/bin/bash
# v2ray Auto Setup 
# =========================
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[information]${Font_color_suffix}"
MYIP=$(wget -qO- ipinfo.io/ip);

clear
# // Detect public IPv4 address and pre-fill for the user
# // Domain

date
domain=$(cat /etc/v2ray/domain)

# // NGINX V2RAY CONF
sudo pkill -f nginx & wait $!
systemctl stop nginx

#rm -rf /etc/nginx/conf.d/alone2.conf
touch /etc/nginx/conf.d/alone2.conf
cat <<EOF >>/etc/nginx/conf.d/alone2.conf
server {
	listen 82;
	listen [::]:82;
	server_name ${domain};
	# shellcheck disable=SC2154
	return 301 https://${domain};
}
server {
		listen 127.0.0.1:32300;
		server_name _;
		return 403;
}
server {
	listen 127.0.0.1:32302 http2;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
    		add_header Content-Type text/plain;
    		alias /etc/config-url/;
    }

    location /v2vlgrpc {
		client_max_body_size 0;
#		keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:32301;
	}

	location /v2trgrpc {
		client_max_body_size 0;
		# keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:32304;
	}
}
server {
	listen 127.0.0.1:32300;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
		add_header Content-Type text/plain;
		alias /etc/config-url/;
	}
	location / {
		add_header Strict-Transport-Security "max-age=15552000; preload" always;
	}
}

EOF

# // Restart Nginx
systemctl daemon-reload
service nginx restart

# // Version V2ray pre
version=$(curl -s https://api.github.com/repos/v2fly/v2ray-core/releases | jq -r '.[]|select (.prerelease==false)|.tag_name' | head -1)

# / / Installation V2ray Core
v2raycore_link="https://github.com/v2fly/v2ray-core/releases/download/${version}/v2ray-linux-64.zip"

# / / Make Main Directory
mkdir -p /etc/mon/v2ray

# / / Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$v2raycore_link" -o v2ray.zip
unzip -q v2ray.zip && rm -rf v2ray.zip
mv v2ray /etc/mon/v2ray
chmod +x /etc/mon/v2ray/v2ray

# // Log
mkdir -p /etc/mon/v2ray
mkdir -p /etc/v2ray
mkdir -p /var/log/v2ray/
mkdir -p /etc/mon/v2ray/conf
touch /etc/v2ray/clients.txt

# // v2ray boot service
touch /etc/systemd/system/v2ray.service

cat <<EOF >/etc/systemd/system/v2ray.service
[Unit]
Description=V2Ray - A unified platform for anti-censorship
Documentation=https://v2ray.com https://guide.v2fly.org
After=network.target nss-lookup.target
Wants=network-online.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
ExecStart=/etc/mon/v2ray/v2ray -confdir /etc/mon/v2ray/conf
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

# // Restart V2ray
systemctl daemon-reload
systemctl enable v2ray.service
rm -rf /etc/mon/v2ray/conf/*

# // Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# // Json File
cat <<EOF >/etc/mon/v2ray/conf/00_log.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  }
}
EOF
cat <<EOF >/etc/mon/v2ray/conf/10_ipv4_outbounds.json
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
cat <<EOF >/etc/mon/v2ray/conf/11_dns.json
{
    "dns": {
        "servers": [
          "localhost"
        ]
  }
}
EOF
cat <<EOF >/etc/mon/v2ray/conf/02_VLESS_TCP_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 8080,
      "protocol": "vless",
      "tag": "V2VLESSTCP",
      "settings": {
        "clients": [],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 32296,
            "xver": 1
          },
          {
            "alpn": "h2",
            "dest": 32302,
            "xver": 0
          },
          {
            "path": "/v2rayws",
            "dest": 32297,
            "xver": 1
          },
          {
            "path": "/v2rayvws",
            "dest": 32299,
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "tlsSettings": {
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
cat <<EOF >/etc/mon/v2ray/conf/03_VLESS_WS_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 32297,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "tag": "V2VLESSWS",
      "settings": {
        "clients": [],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/v2rayws"
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/mon/v2ray/conf/04_trojan_TCP_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 32296,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "V2trojanTCP",
      "settings": {
        "clients": [],
        "fallbacks": [
          {
            "dest":"32300"
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
cat <<EOF >/etc/mon/v2ray/conf/05_VMess_WS_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 32299,
      "protocol": "vmess",
      "tag": "V2VMessWS",
      "settings": {
        "clients": [],
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/v2rayvws"
        }
      }
    }
  ]
}
EOF
cat <<EOF >/etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
    "inbounds":[
    {
        "port": 32301,
        "listen": "127.0.0.1",
        "protocol": "vless",
        "tag":"V2VLESSGRPC",
        "settings": {
            "clients": [],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "grpc",
            "grpcSettings": {
                "serviceName": "v2vlgrpc"
            }
        }
    }
]
}
EOF

cat <<EOF >/etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
    "inbounds": [
        {
            "port": 32304,
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
                "grpcSettings": {
                    "serviceName": "v2trgrpc"
                }
            }
        }
    ]
}
EOF

cat <<EOF >/etc/mon/v2ray/conf/07_trojan_TCP_inbounds.json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 32306,
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

# // System
cat > /etc/systemd/system/v2-vl-xtls.service << EOF
[Unit]
Description=V2Ray Xtls Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/02_VLESS_TCP_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/v2-vl-ws.service << EOF
[Unit]
Description=V2Ray VLess WS Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/03_VLESS_WS_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/v2-tr-grpc.service << EOF
[Unit]
Description=V2Ray Trojan grpc Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/04_trojan_gRPC_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF


cat > /etc/systemd/system/v2-tr-tcp.service << EOF
[Unit]
Description=V2Ray Trojan TLS Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/04_trojan_TCP_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/v2-vm-ws.service << EOF
[Unit]
Description=V2Ray Vmess Ws Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/05_VMess_WS_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/v2-vl-grpc.service << EOF
[Unit]
Description=V2Ray VLess grpc Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/06_VLESS_gRPC_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/v2-tr-xtls.service << EOF
[Unit]
Description=V2Ray Trojan Xtls Service
Documentation=https://speedtest.net https://v2ray.com
After=network.target nss-lookup.target
[Service]
User=root
NoNewPrivileges=true
ExecStart=/etc/mon/v2ray/v2ray -config /etc/mon/v2ray/conf/07_trojan_TCP_inbounds.json
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/v2ray/clients.txt
# user v2ray
EOF

# // v2ray
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 32306 -j ACCEPT

# // v2ray
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8080 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 32306 -j ACCEPT

iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl restart v2ray
systemctl enable v2ray
systemctl restart v2ray.service
systemctl enable v2ray.service
systemctl enable v2-vl-xtls
systemctl restart v2-vl-xtls
systemctl enable v2-vl-ws
systemctl restart v2-vl-ws
systemctl enable v2-tr-grpc
systemctl restart v2-tr-grpc
systemctl enable v2-tr-tcp
systemctl restart v2-tr-tcp
systemctl enable v2-vm-ws
systemctl restart v2-vm-ws
systemctl enable v2-vl-grpc
systemctl restart v2-vl-grpc
systemctl enable v2-tr-xtls
systemctl restart v2-tr-xtls

# // Menu V2ray
cd /usr/bin
wget -O addv2ray "https://raw.githubusercontent.com/Manpokr/multi/main/add/addv2ray.sh"
wget -O cekv2ray "https://raw.githubusercontent.com/Manpokr/multi/main/cek/cekv2ray.sh"
wget -O delv2ray "https://raw.githubusercontent.com/Manpokr/multi/main/del/delv2ray.sh"
wget -O renewv2ray "https://raw.githubusercontent.com/Manpokr/multi/main/renew/renewv2ray.sh"
wget -O trialv2ray "https://raw.githubusercontent.com/Manpokr/multi/main/trial/trialv2ray.sh"
wget -O menu-v2ray "https://raw.githubusercontent.com/Manpokr/multi/main/menu/menu-v2ray.sh"
chmod +x addv2ray
chmod +x delv2ray
chmod +x cekv2ray
chmod +x renewv2ray
chmod +x trialv2ray
chmod +x menu-v2ray

cd

systemctl daemon-reload
systemctl restart nginx
systemctl restart v2ray
clear
echo -e " ${RED}V2RAY INSTALL DONE ${NC}"
sleep 2
clear

rm -f ins-v2ray.sh
