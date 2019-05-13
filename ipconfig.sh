#!/bin/bash -
# 显示内网IP，子网掩码，MAC地址，外网IP
# 无参数
# 2016年 09月 30日 星期五 01:19:33 CST
# 之前一直用ifconfig, 但不同版本输出数据不一样,
# 为了兼容性, 这次改用ip命令(应该不会受LANG的影响),
# kali2016.2和ubuntu14.04中测试成功
# 2016年 01月 14日 星期四 02:44:46 CST
# 修改外网ip接口, 重构并只显示已联LAN的(单个)接口
# 由代码可知不支持多网卡即网桥环境
# 2012-7-6 by needlewang
# 不完美，未连网的网卡有些字段显示不正确,连默认路由跟DNS都没显示

netCard0="eth0"
netCard1="wlan0"
ip_api="https://ipv4.ip.sb/addrinfo"

showlocalIP(){
  echo -ne "$1\n  内网IP:\n\t"
  echo "$2" | grep 'inet ' | awk '{print $2}' | sed 's;/.*$;;'

  echo -ne "  子网掩码:\n\t"
  local subcode=$(echo "$2" | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $2}')
  cat <<EOF | python
mask_bin = ''
mask_list = []
mask_bin = '1' * ${subcode} + '0' * (32 - ${subcode})
for i in range(4):
  an_element = '0b%s' %  mask_bin[i * 8: (i * 8) + 8]
  mask_list.append(str(eval(an_element)))
print('.'.join(mask_list))
EOF

  echo -ne "  mac地址:\n\t"
  echo "$2" | grep 'link/ether' | awk '{print $2}'
}

shownetIP(){
  printf "外网IP:\n\t"  #用echo也行, 这里是为了练习下printf
  local ip_mesg=$(wget -q -O - "$ip_api")
  local wan_ip=$(echo "$ip_mesg" | jq '.address' | sed 's;";;g')
  local province=$(echo "$ip_mesg" | jq '.province' | sed 's;";;g')
  local city=$(echo "$ip_mesg" | jq '.city' | sed 's;";;g')
  local country=$(echo "$ip_mesg" | jq '.country' | sed 's;";;g')
  echo "${wan_ip} ${province} ${city}(${country})"
}

for i in "$netCard0" "$netCard1"
do
    netCardMesg=$(ip addr show "$i")
    if echo "$netCardMesg" | grep -q "inet"; then
        showlocalIP "$i" "$netCardMesg"
        shownetIP
        is_LAN=true
    fi
done

test "$is_LAN" || ifconfig

unset netCard0
unset netCard1
unset ip_api
unset netCardMesg
unset is_LAN
