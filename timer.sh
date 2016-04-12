#!/bin/bash -
#bash timer from linux命令行精选网的微博
#2014年 04月 13日 星期日 04:15:21 CST

MIN=10

for ((i=MIN*60; i>=0; i--))
do
	time=$(date -d "0+$i sec" +%H:%M:%S)
	echo -ne "\r$time"
	sleep 1
done
