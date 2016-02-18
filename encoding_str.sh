#!/bin/bash -
#encoding str to [octonary|decimal|hex|url|unicode] or reverse.
#url_encode also is hex, just change '\x' to '%'
#by needle wang
#needlewang2011@gmail.com

#2014年 04月 28日 星期一 20:30:03 CST
#besides one line, lines including  hex can be parsed.
#no need the format with hex fully.

#2013年 12月 09日 星期一 18:31:24 CST
#add urlencode and reverse using python.

#2013年 11月 29日 星期五 19:29:36 CST
#find hex reverse support 0x61 and %61

#2013年 11月 12日 星期二 09:39:23 CST
#to
#2013年 11月 11日 星期一 22:26:43 CST

#some documents.
#http://mywiki.wooledge.org/BashFAQ/071
#NB!
#variable=$'\x27\047\u0027\U00000027\n'
#echo -n "$variable"

#经测试：
#xxd的默认输出格式跟winhex一模一样
#od -A n -t x1才跟xxd一致
#bc的十六进制只支持大写, 我这个只支持小写, 不改了.

usage(){
echo "useage: $0 [-f file] -d|-h|-o|-u|-U|-H [-r|-O outputfile]
	-d means decimal_to_str
	-h means hex_to_str(0x61 or %61)
	-o means octonary_to_str
	-u means url_encode
	-U means unicode_to_str
	-r means not encode, but decode
	-H means print help
note: it supports pipe.
      don't use -d,-h,-o,-u,-U at the same time.
      reverse means input must be the format data.
"
exit 1
}

urlencode(){
#需要将符号\进行转义,不然传进python会出问题		#2014年 04月 21日 星期一 03:59:24 CST
#另下行原本写的是如下("${char_list}", 多加""后如遇空格，python会报错):
#python -c "import urllib; print urllib.quote(\""${char_list}"\")"

char_list=$(cat $origin_file | sed 's;\\;\\\\;g')
python -c "import urllib; print urllib.quote(\"${char_list}\")"
}

urldecode(){
char_list=$(cat $origin_file)
python -c "import urllib; print urllib.unquote(\"${char_list}\")"
}

str_to_octonary(){
char_list=$(cat $origin_file)
echo -n "${char_list}" | od -A n -t o1
}

octonary_to_str(){
#没有对格式进行验证~, 请规范使用
octal_num=$(cat ${origin_file} | sed 's; ;\\;g' | tr -d '\n')
printf "$octal_num"
}

str_to_decimal(){
char_list=$(cat $origin_file)
echo -n "${char_list}" | od -A n -t d1
}

decimal_to_str(){
#warn: only ascii!!
decimal_num=$(cat ${origin_file})
#变量不能用引号, printf不支持
decimal_to_hex=$(printf ' %x' $decimal_num | sed 's; ;\\x;g')
printf "$decimal_to_hex"
}

str_to_hex(){
char_list=$(cat $origin_file)
#xxd -ps $origin_file | sed 's/[[:xdigit:]]\{2\}/\\x&/g'
echo -n "${char_list}" | od -A n -t x1 | sed 's/ /\\x/g'
}

hex_to_str(){
#method 1:
#没有对格式进行验证～, 请规范使用
#xxd只支持0x41和%61这样的形式, 不支持\x形式, 且-r,-p不能合起来写~
#sed 's/\\x/0x/g' ${origin_file} | xxd -r -p
#2014年 04月 28日 星期一 18:45:52 CST
#增加多行支持, 且允许包含其他字符,但如果包含不想转换\x的就没办法了
sed 's/\\x/0x/g' ${origin_file} | while read -r line
do
	elements_to_parse=$(echo "$line" | grep -Eo '(0x..|%..){1,}')
	for oneElement in $elements_to_parse
	do
			oneElement_parsed=$(echo "$oneElement" | xxd -r -p)
			line=${line/"${oneElement}"/"${oneElement_parsed}"}
	done
	echo "$line"
done

#printf支持变量，但不支持管道及文件~
#printf '\041\x42'

#method 2:
#echo支持管道，但xargs得到的字串内的符号\需转义一次,才能被xargs正确处理	#2014年 04月 21日 星期一 03:54:20 CST

#echo不支持管道，由xargs传给echo会过滤掉\符号,用-I也无用~
#这样可以:但不是很好，没有对数据来源格式进行验证,小心出现奇怪的解析
#if [ "$outputfile" ]
#then
#	file_to_echo="$outputfile"
#else
#	file_to_echo="/dev/stdin"
#fi
#echo -e "$(cat $file_to_echo)"
}

#utf8 to utf16 的算法~
str_to_unicode(){
#赋给变量会省掉最后一个换行符, 如果有的话
char_list=$(cat $origin_file)
unicode_list=''
for ((i=0;i<${#char_list};i++))
do
	#bc要求大写的十六进制
	utf8_char_hex=$(echo -n "${char_list:$i:1}" | xxd -p -u)
	if [ "${#utf8_char_hex}" -eq '2' ]
	then
		unicode_list="${unicode_list}\u00${utf8_char_hex}"
	elif [ "${#utf8_char_hex}" -eq '4' ]
	then
		utf8_char_binary=$(echo "ibase=16;obase=2;${utf8_char_hex}" | bc)
		unicode_list="${unicode_list}$(echo "${utf8_char_binary}" | \
			awk '{print "obase=16;ibase=2;"substr($1,4,5)substr($1,11)}' | \
			bc | tr -d '\n' | sed 's;^;\\u0;')"	#不一定是一个0, 如äöü
	elif [ "${#utf8_char_hex}" -eq '6' ]
	then
		utf8_char_binary=$(echo "ibase=16;obase=2;${utf8_char_hex}" | bc)
		unicode_list="${unicode_list}$(echo "${utf8_char_binary}" | \
			awk '{print "obase=16;ibase=2;"substr($1,5,4)substr($1,11,6)substr($1,19)}' | \
			bc | tr -d '\n' | awk '{if(length==3)$1=0$1}END{print $1}' | sed 's;^;\\u;')"
	fi
done
echo $unicode_list
}

unicode_to_str(){
#没有对格式进行验证～，请规范使用
unicode_num=$(cat ${origin_file})
printf "$unicode_num"
}

while getopts df:hHoO:ruU args
do
	case $args in
	f)
		test -r $OPTARG || {
				echo "can't read $OPTARG."
				exit 1
			}
		origin_file=$OPTARG
	;;
	d)
		which_to_do=d
	;;
	h)
		which_to_do=h
	;;
	o)
		which_to_do=o
	;;
	u)
		which_to_do=u
	;;
	U)
		which_to_do=U
	;;
	O)
		outputfile=$OPTARG
	;;
	r)
		reverse_flag=true
	;;
	H|*)
		usage
	;;
	esac
done

if [ "$reverse_flag" ]
then
	if [ "$which_to_do" == 'd' ]
	then
		result=$(decimal_to_str)
	elif [ "$which_to_do" == 'h' ]
	then
		result=$(hex_to_str)
	elif [ "$which_to_do" == 'o' ]
	then
		result=$(octonary_to_str)
	elif [ "$which_to_do" == 'u' ]
	then
		result=$(urldecode)
	elif [ "$which_to_do" == "U" ]
	then
		result=$(unicode_to_str)
	else
		usage
	fi
else
	if [ "$which_to_do" == 'd' ]
	then
		result=$(str_to_decimal)
	elif [ "$which_to_do" == 'h' ]
	then
		result=$(str_to_hex)
	elif [ "$which_to_do" == 'o' ]
	then
		result=$(str_to_octonary)
	elif [ "$which_to_do" == 'u' ]
	then
		result=$(urlencode)
	elif [ "$which_to_do" == 'U' ]
	then
		result=$(str_to_unicode)
	else
		usage
	fi
fi

test "$outputfile" && echo "$result" >"$outputfile" || echo "$result"


