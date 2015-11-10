#!/bin/bash -
#修改自微博(id为commandline精选网)
#2014年 04月 22日 星期二 23:17:00 CST

LANG=C

while true
do
	now_time=$(date)
	echo -ne "\e[s\e[0;$(($(tput cols)-$(echo $now_time|wc -c)))H${now_time}\e[u"
	sleep 1
done &

