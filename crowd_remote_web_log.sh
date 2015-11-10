#!/bin/bash -
#crowd the target' web log.
#by needle
#2013年 12月 02日 星期一 05:26:56 CST

test "$1" || {
				echo 'need a url.'
				exit 1
			}
i=1
while true; do
	if [ $i -eq 1000 ]; then
		break
	fi
	wget -q --user-agent="Googlebot/2.1 (http://www.googlebot.com/bot.html)" -O /dev/null ${1} &
	#echo "times: ${i}"
	((i++))
done
