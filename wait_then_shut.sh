#!/bin/bash -
#看样子，还可用于等待其他进程结束后关机
#当虚拟机关机(快盘在同步)后, 关闭ubuntu
#2014年 04月 08日 星期二 01:57:15 CST

if [ ! "$1" ]; then
    echo 'need a pid which is $1'
    exit 1
fi

while true
do
	sleep 2m
	#如果虚拟机的PID没有后关闭物理机
	if ! ps -p "$1" >/dev/null
	then
		break
	fi
done

shutdown -h now

