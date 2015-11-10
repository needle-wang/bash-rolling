#!/bin/bash -
#
#2014年 12月 08日 星期一 22:38:45 CST

while true
do
    echo -ne "\r$(du -sh .)"
    sleep 1s
done

