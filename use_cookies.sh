#!/bin/bash -
#use cookies from wireshark.
#format the cookies into json for chrome's Edit this cookie
#by needlewang
#2014年 04月 29日 星期二 01:23:48 CST
#pick up some unregular cookie's value with '='
#and some values are wrapped like  '"..."', ugly.
#2014年 04月 28日 星期一 21:12:03 CST
#add the pipe(just add test "$1" == "-").
#2013年 10月 28日 星期一 06:14:10 CST

([ -r "$1" -o "$1" == "-" ]) || {
echo "
format the cookies into json for chrome's Edit this cookie

alternative 1:
echo 'Cookie:...' | $0 - .google.com

alternative 2:
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

by needlewang
needlewang2011@gmail.com
"
exit 1;
}

test "$2" || {
echo "need a domain, which is from HTTP Packet. like:
$0 cookie.txt .google.com

by needlewang
needlewang2011@gmail.com
"
exit 2
}


domain="$2"
cookies=$(grep -i '^[ 	]*Cookie:' "$1")
cookies=$(echo "$cookies" | sed 's/^[[:space:]]*Cookie: *//;s/; */\n/g')

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
	#name=$(echo "$one" | awk -F'=' '{print $1}')
	#value=$(echo "$one" | awk -F'=' '{print $2}')
	#unfortunately, some cookies does contains '=', so:
	name=$(echo "$one" | cut -d'=' -f1)
	value=$(echo "$one" | cut -d'=' -f2-)
	echo '    "name": "'"$name"'",'
	echo '    "path": "'"/"'",'
	#echo '    "value": "'"$value"'"'
	echo '    "value": "'"${value//\"/\\\"}"'"'
	#count can not be used in pipe..., so:
	((count++))
	if [ "$count" -lt "$max_line_number" ]
	then
		echo '},'
	else
		echo '}]'
	fi
done

