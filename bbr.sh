#!/bin/bash

RED='\e[1;31m'
GREEN='\e[0;32m'
NC='\e[0m'

# // Optimasi Speed By LostServer
Add_To_New_Line(){
	if [ "$(tail -n1 $1 | wc -l)" == "0"  ];then
		echo "" >> "$1"
	fi
	echo "$2" >> "$1"
}

Check_And_Add_Line(){
	if [ -z "$(cat "$1" | grep "$2")" ];then
		Add_To_New_Line "$1" "$2"
	fi
}

Install_BBR(){
echo "#############################################"
echo "Install TCP_BBR..."
if [ -n "$(lsmod | grep bbr)" ];then
echo "TCP_BBR sudah diinstall."
echo "#############################################"
return 1
fi
echo "Mulai menginstall TCP_BBR..."
modprobe tcp_bbr
Add_To_New_Line "/etc/modules-load.d/modules.conf" "tcp_bbr"
Add_To_New_Line "/etc/sysctl.conf" "net.core.default_qdisc = fq"
Add_To_New_Line "/etc/sysctl.conf" "net.ipv4.tcp_congestion_control = bbr"
sysctl -p
if [ -n "$(sysctl net.ipv4.tcp_available_congestion_control | grep bbr)" ] && [ -n "$(sysctl net.ipv4.tcp_congestion_control | grep bbr)" ] && [ -n "$(lsmod | grep "tcp_bbr")" ];then
	echo "TCP_BBR Install Success."
else
	echo "Gagal menginstall TCP_BBR."
fi
echo "#############################################"
}

Optimize_Parameters(){
echo "#############################################"
echo "Optimasi Parameters..."
Check_And_Add_Line "/etc/security/limits.conf" "* soft nofile 51200"
Check_And_Add_Line "/etc/security/limits.conf" "* hard nofile 51200"
Check_And_Add_Line "/etc/security/limits.conf" "root soft nofile 51200"
Check_And_Add_Line "/etc/security/limits.conf" "root hard nofile 51200"
Check_And_Add_Line "/etc/sysctl.conf" "fs.file-max = 51200"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.rmem_max = 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.wmem_max = 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.netdev_max_backlog = 250000"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.somaxconn = 4096"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_syncookies = 1"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_tw_reuse = 1"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fin_timeout = 30"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_keepalive_time = 1200"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.ip_local_port_range = 10000 65000"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_max_syn_backlog = 8192"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_max_tw_buckets = 5000"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fastopen = 3"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_mem = 25600 51200 102400"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_rmem = 4096 87380 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_wmem = 4096 65536 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_mtu_probing = 1"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_low_latency = 1"

Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.all.disable_ipv6 = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.default.disable_ipv6 = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.lo.disable_ipv6 = 0

Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.all.accept_ra = 2
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.default.accept_ra = 2

Check_And_Add_Line "/etc/sysctl.conf" "net.core.Check_And_Add_Line "/etc/sysctl.conf" "netdev_m>
Check_And_Add_Line "/etc/sysctl.conf" "net.core.Check_And_Add_Line "/etc/sysctl.conf" "netdev_b>
Check_And_Add_Line "/etc/sysctl.conf" "net.core.Check_And_Add_Line "/etc/sysctl.conf" "netdev_b>

Check_And_Add_Line "/etc/sysctl.conf" "net.core.rmem_max = 67108864
Check_And_Add_Line "/etc/sysctl.conf" "net.core.wmem_max = 67108864
Check_And_Add_Line "/etc/sysctl.conf" "net.core.rmem_default = 65536
Check_And_Add_Line "/etc/sysctl.conf" "net.core.wmem_default = 65536
Check_And_Add_Line "/etc/sysctl.conf" "net.core.somaxconn = 10000

Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.icmp_echo_ignore_all = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.icmp_echo_ignore_broadcasts = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.icmp_ignore_bogus_error_responses = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.all.accept_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.default.accept_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.all.secure_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.default.secure_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.all.send_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.default.send_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.default.rp_filter = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.all.rp_filter = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_rfc1337 = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_timestamps = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_syncookies = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_tw_recycle = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_tw_reuse = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fin_timeout = 10
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_keepalive_time = 1200
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_keepalive_intvl = 10
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_keepalive_probes = 6
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.ip_local_port_range = 10000 65000
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_max_tw_buckets = 2000000
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fastopen = 3
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_rmem = 4096 87380 67108864
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_wmem = 4096 65536 67108864
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.udp_rmem_min = 8192
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.udp_wmem_min = 8192
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_mtu_probing = 0

Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.all.arp_ignore = 2
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.default.arp_ignore = 2
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.all.arp_announce = 2
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.conf.default.arp_announce = 2

Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_autocorking = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_slow_start_after_idle = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_max_syn_backlog = 30000
Check_And_Add_Line "/etc/sysctl.conf" "net.core.default_qdisc = fq
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_congestion_control = bbr
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_ecn = 2
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_ecn_fallback = 1
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_frto = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fack = 0

Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.all.accept_redirects = 0
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv6.conf.default.accept_redirects = 0
vm.swappiness = 5
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.ip_unprivileged_port_start = 0
echo "Optimasi Parameters Selesai."
echo "#####################################"
}
Install_BBR
Optimize_Parameters
rm -f /root/bbr.sh
