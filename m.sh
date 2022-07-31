# // Info
sleep 2
echo ""
echo -e "\e[33m━━━━━━━━━[\e[0m \e[32mManternet\e[0m \e[33m]━━━━━━━━━━━\e[0m"
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200"  | tee -a log-install.txt
echo "   - Stunnel4                : 444, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8000 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81, 82"  | tee -a log-install.txt
echo "   - XRAY VLESS XTLS SPLICE  : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS XTLS DIRECT  : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS WS TLS       : 443"  | tee -a log-install.txt
echo "   - XRAY TROJAN TLS         : 443"  | tee -a log-install.txt
echo "   - XRAY VMESS TLS          : 443"  | tee -a log-install.txt
echo "   - Trojan-GFW              : 2087" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                 : Asia/Kuala_Lumpur (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                 : [ON]"  | tee -a log-install.txt
echo "   - DDOS Dflate              : [ON]"  | tee -a log-install.txt
echo "   - IPtables                 : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot              : [OFF]" | tee -a log-install.txt
echo "   - IPv6                     : [OFF]" | tee -a log-install.txt
echo "   - Auto-Remove-Expired      : [ON]"  | tee -a log-install.txt                
echo "   - AutoKill Multi Login User       " | tee -a log-install.txt
echo "   - Auto Delete Expired Account     " | tee -a log-install.txt
echo "   - Fully automatic script          " | tee -a log-install.txt
echo "   - VPS settings                    " | tee -a log-install.txt
echo "   - Admin Control                   " | tee -a log-install.txt
echo "   - Change port                     " | tee -a log-install.txt
echo "   - Restore Data                    " | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo -e "\e[33m━━━━━━━━━[\e[0m \e[32mManternet\e[0m \e[33m]━━━━━━━━━━━\e[0m"
echo ""
