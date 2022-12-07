#!/bin/bash
#wget https://github.com/${GitUser}/
GitUser="akuhaa021"

# PROVIDED
creditt=$(cat /root/provided)
# TEXT ON BOX COLOUR
box=$(cat /etc/box)
# LINE COLOUR
line=$(cat /etc/line)
# BACKGROUND TEXT COLOUR
back_text=$(cat /etc/back)
clear
IP=$(wget -qO- icanhazip.com);
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /usr/local/etc/xray/domain)
else
domain=$IP
fi
echo -e   "  \e[$line═══════════════════════════════════════════════════════\e[m"
echo -e   "  \e[$back_text              \e[30m[\e[$box CREATE USER SHADOWSOCKSR\e[30m ]\e[1m             \e[m"
echo -e   "  \e[$line═══════════════════════════════════════════════════════\e[m"
echo "   Please enter the username for Acc ShadowsocksR"
read -e -p "   Username:" ssr_user
CLIENT_EXISTS=$(grep -w $ssr_user /usr/local/shadowsocksr/akun.conf | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
echo ""
echo "A client with the specified name was already created, please choose another name."
exit 1
fi
read -p "   Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
harini=`date -d "0 days" +"%Y-%m-%d"`
lastport=$(cat /usr/local/shadowsocksr/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 )
if [[ $lastport == '' ]]; then
ssr_port=1443
else
ssr_port=$((lastport+1))
fi
ssr_password="$ssr_user"
ssr_method="aes-256-cfb"
ssr_protocol="origin"
ssr_obfs="tls1.2_ticket_auth_compatible"
ssr_protocol_param="2"
ssr_speed_limit_per_con=0
ssr_speed_limit_per_user=0
ssr_transfer="838868"
ssr_forbid="bittorrent"
cd /usr/local/shadowsocksr
match_add=$(python mujson_mgr.py -a -u "${ssr_user}" -p "${ssr_port}" -k "${ssr_password}" -m "${ssr_method}" -O "${ssr_protocol}" -G "${ssr_protocol_param}" -o "${ssr_obfs}" -s "${ssr_speed_limit_per_con}" -S "${ssr_speed_limit_per_user}" -t "${ssr_transfer}" -f "${ssr_forbid}"|grep -w "add user info")

cat > /usr/local/shadowsocksr/$ssr_user-clash-for-android.yaml <<-END
# Generated Vmess with Clash For Android
# Generated by V-Code
# Credit : Clash For Android

# CONFIG CLASH SHADOWSOCKSR
port: 7890
socks-port: 7891
allow-lan: true
mode: Rule
log-level: info
external-controller: 127.0.0.1:9090
proxies:
  - {name: $domain, server: $domain, port: $ssr_port, type: ssr, cipher: aes-256-cfb, password: $ssr_password, protocol: origin, obfs: tls1.2_ticket_auth, protocol-param: "", obfs-param: bug.com}
proxy-groups:
  - name: 🚀 节点选择
    type: select
    proxies:
      - ♻️ 自动选择
      - DIRECT
      - $domain
  - name: ♻️ 自动选择
    type: url-test
    url: http://www.gstatic.com/generate_204
    interval: 300
    tolerance: 50
    proxies:
      - $domain
  - name: 🌍 国外媒体
    type: select
    proxies:
      - 🚀 节点选择
      - ♻️ 自动选择
      - 🎯 全球直连
      - $domain
  - name: 📲 电报信息
    type: select
    proxies:
      - 🚀 节点选择
      - 🎯 全球直连
      - $domain
  - name: Ⓜ️ 微软服务
    type: select
    proxies:
      - 🎯 全球直连
      - 🚀 节点选择
      - $domain
  - name: 🍎 苹果服务
    type: select
    proxies:
      - 🚀 节点选择
      - 🎯 全球直连
      - $domain
  - name: 📢 谷歌FCM
    type: select
    proxies:
      - 🚀 节点选择
      - 🎯 全球直连
      - ♻️ 自动选择
      - $domain
  - name: 🎯 全球直连
    type: select
    proxies:
      - DIRECT
      - 🚀 节点选择
      - ♻️ 自动选择
  - name: 🛑 全球拦截
    type: select
    proxies:
      - REJECT
      - DIRECT
  - name: 🍃 应用净化
    type: select
    proxies:
      - REJECT
      - DIRECT
  - name: 🐟 漏网之鱼
    type: select
    proxies:
      - 🚀 节点选择
      - 🎯 全球直连
      - ♻️ 自动选择
      - $domain
END
# masukkan payloadnya ke dalam config yaml
cat /etc/openvpn/server/sr.key >> /usr/local/shadowsocksr/$ssr_user-clash-for-android.yaml

# Copy config Yaml client ke home directory root agar mudah didownload ( YAML )
cp /usr/local/shadowsocksr/$ssr_user-clash-for-android.yaml /home/vps/public_html/$ssr_user-clash-for-android.yaml

cd
echo -e "${Info} Succesfully create new user [username: ${ssr_user}]"
echo -e "### $ssr_user $exp" >> /usr/local/shadowsocksr/akun.conf
tmp1=$(echo -n "${ssr_password}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${ssr_obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "$domain:${ssr_port}:${ssr_protocol}:${ssr_method}:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"
/etc/init.d/ssrmu restart
service cron restart
clear
echo -e ""
echo -e "\e[$line═════════[ShadowsocksR]══════════\e[m"
echo -e " User          : ${ssr_user}"
echo -e " Domain        : ${domain}"
echo -e " IP/Host       : ${MYIP}"
echo -e " Port          : ${ssr_port}"
echo -e " Password      : ${ssr_password}"
echo -e " Encryption    : ${ssr_method}"
echo -e " Protocol      : ${Red_font_prefix}${ssr_protocol}"
echo -e " Obfs          : ${Red_font_prefix}${ssr_obfs}"
echo -e " Device limit  : ${ssr_protocol_param}"
echo -e " Support Yaml  : YES"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e " Link SSR      : ${ssr_link}"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e " Link Yaml     : http://$MYIP:81/$ssr_user-clash-for-android.yaml"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e " Created       : ${harini}"
echo -e " Expired       : ${exp} "
echo -e " Script By $creditt"