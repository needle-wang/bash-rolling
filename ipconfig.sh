#!/bin/bash -

#显示内网IP，子网掩码，MAC地址，外网IP
#无参数
#2012-7-6 by needlewang
#不完美，未连网的网卡有些字段显示不正确,连默认路由跟DNS都没显示

netCard0="eth0"
netCard1="wlan0"

#test:
#ifconfig eth0|awk '/inet/ {split($2,x,":");print x[2]}'

showIP(){
echo $1|awk '{print "  内网IP:";split($7,x,":");print "\t" x[2];split($9,x,":");print "  子网掩码:\n\t" x[2] "\n  mac地址:\n\t" $5}'

#printf "外网IP:\n\t"
#w3m -no-cookie -dump iframe.ip138.com/city.asp|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'

}


echo $netCard0
netCardMessage=`ifconfig $netCard0`
showIP "$netCardMessage"

echo $netCard1
netCardMessage=`ifconfig $netCard1`
showIP "$netCardMessage"

printf "外网IP:\n\t"
#w3m -no-cookie -dump iframe.ip138.com/city.asp | sed -e 's;.*\[;\[;' -e 's;来自：;<;' -e 's;$;>;'
wget -q -O - 'http://1111.ip138.com/ic.asp' | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}'

unset $netCard0
unset $netCard1
unset $netCarMessage
