#/bin/bash -
#top plus about realtime
#top to grep
#第2个参数如果是数字则为行号...
#第2个参数如果是非数字则是关键字，且第3个参数如果存在，会覆盖第2个参数。
#by needle wang
#2013年 04月 14日 星期日 11:50:36 CST

LANG=C

if [ a"$1" == a"-h" ]
then
	echo "$0 [option] [lineNumber] [keyword]"
	exit 0
fi

$(echo "$2" | grep -q '^[0-9]\+$') && lines=$2 || keyword=$2

if [ ! "${lines}" ] || [ "${lines}" -le "0" ]
then
	lines=10
fi

#提取结果
#top非交互模式的cmdline列会根据终端大小截断
#所以设成最大列长再执行，去掉结尾所有空格，然后恢复默认值(不然列太长显示会有问题)
oldcols=$(tput cols)
stty cols 1024
result=$(top -cbn1 | sed '0,/^$/d;s;[ ]*$;;g')
stty cols ${oldcols}
#header
header=$(echo "${result}" | sed -n '1p')
result=$(echo "${result}" | tail -n +2)
#以下会报错：-bash: echo: write error: 断开的管道，原因未知
#echo "${result}" | head -1

#占cpu最高的前10个进程
if [ "$1" == "-cpu" ]
then
field=9
fi
#占memory最高的前10个进程
if [ "$1" == "-mem" ]
then
	field=10
fi
if [ $field ]
then
	echo "${header}"
	resultsortedbycpu=$(echo "${result}" | sort -nrk $field | head -n ${lines})
	if [ "$3" ]
	then
		keyword=$3
	fi
	if [ "${keyword}" ]
	then
		echo "${resultsortedbycpu}" | grep "${keyword}";
		exit 0
	fi
	echo "${resultsortedbycpu}"
	exit 0
fi

#ps出的vsz总数
if [ "$1" == "-vsz" ]
then
	echo "VSZ_total"
	ps aux | tail -n +2 | awk '{print $5}' | tr '\n' '+' | sed 's;$;0\n;g' | bc
	exit 0
fi

#ps出的RSS总数
if [ "$1" == "-rss" ]
then
	echo "RSS_total"
	ps aux | tail -n +2 | awk '{print $6}' | tr '\n' '+' | sed 's;$;0\n;g' | bc
	exit 0
fi

echo "${header}"
#查找关键字
if [ "$1" ]
then
	echo "${result}" | grep --color=auto -- $1
else
	#无关键字则输出所有进程
	echo "${result}"
fi

