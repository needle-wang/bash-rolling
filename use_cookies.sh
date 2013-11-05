#!/bin/bash -
#use cookies from wireshark.
#format the cookies into json for chrome's Edit this cookie
#by needlewang
#2013年 10月 28日 星期一 06:14:10 CST

test -r "$1" || {
echo "
step 1:
Run wireshark, then the filter is like:
http.cookie contains "skey"

step 2:
select a HTTP line in Packet List.
Find the Cookie line from Packet Details,
right click at the Cookie line:
copy -> Bytes -> Printable Text Only.

step 3:
put them in a void or blank file.

stop 4:
then, tell me where is the file, which is one line.
like: $0 cookie.txt .google.com
"
exit 1;
}

test "$2" || {
echo "need a domain, which is from HTTP Packet. like:
$0 cookie.txt .google.com
"
exit 2
}


domain="$2"
cookies=$(grep 'Cookie:' "$1")
cookies=$(echo "$cookies" | sed 's/Cookie: //;s/; /\n/g')

#don't use wc.
max_line_number=$(echo "$cookies" | awk 'END{print NR}')
count=0

echo -n '['

IFS=$'\n'

#hope no special charactor...
#or use while in pipe.
for one in $cookies
do
	echo '{'
	echo '    "domain": "'"$domain"'",'
	#cookie's name or value should not contains '='
	name=$(echo "$one" | awk -F'=' '{print $1}')
	value=$(echo "$one" | awk -F'=' '{print $2}')
	echo '    "name": "'"$name"'",'
	echo '    "path": "'"/"'",'
	echo '    "value": "'"$value"'"'
	#count can not be used in pipe...
	((count++))
	if [ "$count" -lt "$max_line_number" ]
	then
		echo '},'
	else
		echo '}]'
	fi
done

