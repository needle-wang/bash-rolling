#/bin/bash -
#第2个参数如果是数字则为行号...
#第2个参数如果是非数字则是关键字，且第3个参数如果存在，会覆盖第2个参数。
#how boring.It should be thrown to trash...
#2013-04-02 星期二 18:59

LANG=C

if [ a"$1" == a"-h" ]
then
	echo "$0 [option] [lineNumber] [keyword]"
	exit 0
fi

$(echo "$2"|grep -q '^[0-9]\+$') && lines=$2 || keyword=$2

if [ ! "${lines}" ] || [ "${lines}" -le "0" ]
then
	lines=10
fi

#占cpu最高的前10个进程
if [ "$1" == "-cpu" ]
then
	cmd="ps auxw | head -1;ps auxw | grep -v PID | sort -rnk3 | head -n ${lines}"
	if [ "$3" ]
	then
		keyword=$3
	fi
	if [ "${keyword}" ]
	then
		cmd=$(echo ${cmd} | sed "s;$; | grep ${keyword};")
	fi
	echo "${cmd}" | bash
	exit 0
fi

#占memory最高的前10个进程
if [ "$1" == "-mem" ]
then
	cmd="ps auxw | head -1;ps auxw | grep -v PID | sort -rnk4 | head -n ${lines}"
	if [ "$3" ]
	then
		keyword=$3
	fi
	if [ "${keyword}" ]
	then
		cmd=$(echo ${cmd} | sed "s;$; | grep ${keyword};")
	fi
	echo "${cmd}" | bash
	exit 0
fi

#ps出的vsz总数
if [ "$1" == "-vsz" ]
then
	echo "VSZ_total"
	ps aux | tail -n +2 | awk '{print $5}' | tr '\n' '+' | sed 's;$;0\n;g'|bc
	exit 0
fi

#ps出的RSS总数
if [ "$1" == "-rss" ]
then
	echo "RSS_total"
	ps aux | tail -n +2 | awk '{print $6}' | tr '\n' '+' | sed 's;$;0\n;g'|bc
	exit 0
fi

#查找关键字
if [ "$1" ]
then
	ps auxw | head -1;
	ps auxw | grep -- $1
	exit 0
fi

#无关键字则输出所有进程
ps auxw


