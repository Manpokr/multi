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

# install
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

installType='apt -y install'
source /etc/os-release
release=$ID
ver=$VERSION_ID

if [[ "${release}" == "debian" ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y 
		echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
		echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
		curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key 
		# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
		sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
		sudo apt update 
                apt -y install nginx

elif [[ "${release}" == "ubuntu" ]]; then
		sudo apt install gnupg2 ca-certificates lsb-release -y 
		echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
		echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx 
		curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
		# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
		sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
		sudo apt update 
                apt -y install nginx
fi

systemctl daemon-reload
systemctl enable nginx

# // Install nginx
sudo pkill -f nginx & wait $!
systemctl stop nginx
sudo apt install gnupg2 ca-certificates lsb-release -y
systemctl daemon-reload
systemctl enable nginx

touch /etc/nginx/conf.d/alone.conf
cat <<EOF >>/etc/nginx/conf.d/alone.conf
server {
	listen 81;
	listen [::]:81;
	server_name ${domain};
	# shellcheck disable=SC2154
	return 301 https://${domain};
}
server {
		listen 127.0.0.1:31300;
		server_name _;
		return 403;
}
server {
	listen 127.0.0.1:31302 http2;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
    		add_header Content-Type text/plain;
    		alias /etc/mon/config-url/;
    }
    location /xraygrpc {
		client_max_body_size 0;
#		keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:31301;
	}
	location /xraytrojangrpc {
		client_max_body_size 0;
		# keepalive_time 1071906480m;
		keepalive_requests 4294967296;
		client_body_timeout 1071906480m;
 		send_timeout 1071906480m;
 		lingering_close always;
 		grpc_read_timeout 1071906480m;
 		grpc_send_timeout 1071906480m;
		grpc_pass grpc://127.0.0.1:31304;
	}
}
server {
	listen 127.0.0.1:31300;
	server_name ${domain};
	root /usr/share/nginx/html;
	location /s/ {
		add_header Content-Type text/plain;
		alias /etc/mon/config-url/;
	}
	location / {
		add_header Strict-Transport-Security "max-age=15552000; preload" always;
	}
}
EOF

mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf
systemctl daemon-reload
service nginx restart
cd

rm -rf /usr/share/nginx/html
wget -q -P /usr/share/nginx https://raw.githubusercontent.com/Manpokr/multi/main/html/html.zip 
unzip -o /usr/share/nginx/html.zip -d /usr/share/nginx/html 
rm -f /usr/share/nginx/html.zip*
chown -R www-data:www-data /usr/share/nginx/html

curl https://raw.githubusercontent.com/Manpokr/multi/main/nginx.conf > /etc/nginx/nginx.conf
curl https://raw.githubusercontent.com/Manpokr/multi/main/vps.conf > /etc/nginx/conf.d/vps.conf
mkdir -p /home/vps/public_html

# // Xray Version
#version=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | jq -r .[4].tag_name|head -1)

# / / Installation Xray Core
#xraycore_link="https://github.com/XTLS/Xray-core/releases/download/$version/xray-linux-64.zip"

# / / Make Main Directory
mkdir -p /etc/xray
mkdir -p /etc/xray/conf

# / / Unzip Xray Linux 64
#cd `mktemp -d`
#curl -sL "$xraycore_link" -o xray.zip
#unzip -q xray.zip && rm -rf xray.zip
#mv xray /etc/mon/xray
#chmod +x /etc/mon/xray/xray

echo " ---> Xray-core version:${version}"
if wget --help | grep -q show-progress; then
		wget -c -q --show-progress -P /etc/mon/xray/ "https://github.com/XTLS/Xray-core/releases/download/v1.4.5/Xray-linux-64.zip"
else
		wget -c -P /etc/mon/xray/ "https://github.com/XTLS/Xray-core/releases/download/v1.4.5/Xray-linux-64.zip"
fi

unzip -o /etc/mon/xray/Xray-linux-64.zip -d /etc/mon/xray 
rm -rf /etc/mon/xray/Xray-linux-64.zip
chmod 655 /etc/mon/xray/xray

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
systemctl stop xray
systemctl start xray
systemctl enable xray.service

# CertV2ray
curl -s https://get.acme.sh | sh
/root/.acme.sh/acme.sh  --upgrade  --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --register-account -m anjang614@gmail.com 
/root/.acme.sh/acme.sh --issue -d ${domain} --standalone -k ec-256 --server letsencrypt --force >> /etc/mon/tls/$domain.log
~/.acme.sh/acme.sh --installcert -d ${domain} --fullchainpath /etc/mon/tls/xray.crt --keypath /etc/mon/tls/xray.key --ecc
cat /etc/mon/tls/$domain.log

rm -rf /etc/mon/xray/conf/*
# // Uuid Service
#uuid=$(/etc/mon/xray/xray uuid
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
            {"dest": "31300"}
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
                "clients": [
                  {
                      "password": "${uuid}",
                      "email": "${domain}_trojan_gRPC"
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
                    "serviceName": "trgrpc"
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
    "loglevel": "warning"
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

cat <<EOF >/etc/mon/xray/conf/02_VLESS_TCP_inbounds.json
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
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
              "certificateFile": "/etc/mon/tls/xray.crt",
              "keyFile": "/etc/mon/tls/xray.key",
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
            "dest": "31333"
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

cat> /etc/mon/xray/conf/none.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 80,
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
    "error": "/var/log/xray/error2.log",
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

cat <<EOF >/etc/mon/xray/conf/11_dns.json
{
    "dns": {
        "servers": [
          "localhost"
        ]
  }
}
EOF

sleep 1
echo -e "[\e[32mINFO\e[0m] Installing bbr.."
wget -q -O /usr/bin/bbr "https://raw.githubusercontent.com/Manpokr/multi/main/addon/bbr.sh"
chmod +x /usr/bin/bbr


# // xray
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31230 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31304 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 31297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 880 -j ACCEPT

# // xray
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31230 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31301 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31299 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31296 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31304 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 31297 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 8080 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 880 -j ACCEPT

iptables-save >/etc/iptables.rules.v4
netfilter-persistent save
netfilter-persistent reload

# // Starting
systemctl daemon-reload
systemctl restart xray
systemctl enable xray
systemctl restart xray.service
systemctl enable xray.service

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


rm -f ins-xray.sh
clear
echo -e " ${RED}XRAY INSTALL DONE ${NC}"
sleep 2
clear

cp /root/domain /etc/xray
systemctl daemon-reload
systemctl restart nginx
systemctl restart xray
