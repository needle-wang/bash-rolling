#!/bin/bash -
#使用chnroutes修改vpn的路由
#向route表中添加国内ip段, 使得vpn访问国内网站时 不经过ppp0(即VPN)
#chnroutes.py默认要先连vpn再进行操作, 此脚本会有向导, 根据提示操作即可.
#https://gist.github.com/dearmark/a66cfc7626e3c017b01f
#2016年 03月 30日 星期三 13:14:54 CST

upfile="/etc/ppp/ip-pre-up"
downfile="/etc/ppp/ip-down.d/ip-down"
route_line_num=$(ip route show | wc -l)

#如果是更新chnroutes, 且已连vpn
if [ $(ip route show | wc -l) -gt 100 ]; then
    read -p "please disconnect the vpn and press [Enter] "
fi

test -e "$upfile" && sudo rm -v "$upfile"
test -e "$downfile" && sudo rm -v "$downfile"

read -p "now, make sure a vpn has connected, then press [Enter] "

cd "${HOME}/bin" || exit 1

if [ ! -e "chnroutes.py" ]; then
    wget https://raw.github.com/fivesheep/chnroutes/master/chnroutes.py
fi

python chnroutes.py -p linux

sudo mv ip-pre-up /etc/ppp
sudo chmod +x "$upfile"

sudo mv ip-down /etc/ppp/ip-down.d
sudo chmod +x "$downfile"

echo 'now, reconnect the vpn.'
echo 'after reconnect, check result by "ip route show".'

