#!/bin/bash -
#显示内网IP，子网掩码，MAC地址，外网IP
#无参数
#2012-7-6 by needlewang
#不完美，未连网的网卡有些字段显示不正确,连默认路由跟DNS都没显示
#2016年 01月 14日 星期四 02:44:46 CST
#修改外网ip接口, 重构并只显示已联LAN的(单个)接口
#由代码可知不支持多网卡即网桥环境

netCard0="eth0"
netCard1="wlan0"

#test:
#ifconfig eth0|awk '/inet/ {split($2,x,":");print x[2]}'

showlocalIP(){
echo $1
echo $2|awk '{print "  内网IP:";split($7,x,":");print "\t" x[2];split($9,x,":");print "  子网掩码:\n\t" x[2] "\n  mac地址:\n\t" $5}'
}

shownetIP(){
printf "外网IP:\n\t"
wget -q -O - "www.ipip.net/ip.php" | grep -o 'color: rgb(243, 102, 102).*/' | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}'

}


for i in "$netCard0" "$netCard1"
do
    netCardMessage=$(ifconfig "$i")
    if echo "$netCardMessage" | grep -q "inet"; then
        showlocalIP "$i" "$netCardMessage"
        shownetIP
    fi
done

unset $netCard0
unset $netCard1
unset $netCarMessage
