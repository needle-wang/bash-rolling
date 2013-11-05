#!/bin/bash -
#modify the tomcat's port(s).
#if you would put several tomcats in a Linux...
#use it to modify the web port,shutdown port,AJP1.3 port.
#test it successfully with tom6 and tom7.
#by needle wang
#version2:
#2013-05-02 星期四 10:44
#add -l option
#version1:
#2013年05月 1日  2:43:46

#修改的文件默认为当前目录下的server.xml
configfile=server.xml

lsports(){
	if [ ! -e $configfile ] || [ ! -r $configfile ]
	then
		echo "the file: $configfile does not exist or need r permition."
		return 2
	fi

	echo "(if it is possible, printing the absolute path ,would be better...)"
	echo -n "web port is: "
	sed -n "/on port 8080/,/<!--/p" $configfile | grep -o '<Connector.*protocol' | grep -o '[1-9][0-9]*'
	echo -n "shutdown port is: "
	sed -n "/shutdown/p" $configfile |grep -o '<Server.*shutdown' | grep -o '[1-9][0-9]*'
	echo -n "AJP1.3 port is: "
	sed -n "/on port 8009/,/<!--/p" $configfile | grep -o '<Connector.*protocol' | grep -o '[1-9][0-9]*'
}

while getopts hlf:w:s:a: args
do
	case $args in
	f)
		configfile=$OPTARG
	;;
	w)

		if echo "$OPTARG" | grep -q '^[1-9][0-9]*$'
		then
			webport=$OPTARG
		else
			echo "need the web port which is greater than zero(should not be so weird...)."
			exit 3
		fi
	;;
	s)
		if echo "$OPTARG" | grep -q '^[1-9][0-9]*$'
		then
			shutdownport=$OPTARG
		else
			echo "need a legal shutdown port number."
			exit 3
		fi
	;;
	a)
		if echo "$OPTARG" | grep -q '^[1-9][0-9]*$'
		then
			ajpport=$OPTARG
		else
			echo "need a legal AJP1.3 port number."
			exit 3
		fi
	;;
	l)
		lsports && exit 0 || exit 2
	;;
	*)
		echo "usage:$(basename $0) [-f configfile | -w webport | -s shutdownport | -a AJP1.3port | -l | -h]"
		exit 1
	;;
	esac
done

#首先配置文件要是可读可写的，不然无法操作
if [ ! -e $configfile ] || [ ! -r $configfile ] || [ ! -w $configfile ]
then
	echo "the file: $configfile does not exist or need rw permition."
	exit 2
fi

if [ ! "$webport" ] && [ ! "$shutdownport" ] && [ ! "$ajpport" ]
then
	echo "do what?"
	echo "usage:$(basename $0) [-f configfile | -w webport | -s shutdownport | -a AJP1.3port | -l | -h]"
	exit 1
fi

#如果指定了web端口则修改它
if [ "$webport" ]
then
	echo "modifing the web port..."
	sed -i "/on port 8080/,/<!--/s;port=\"[^\"]*\";port=\"${webport}\";" ${configfile} && echo -e "\tok. the web port is ${webport}" || echo failure.
fi

#如果指定了shutdown端口则修改它
if [ "$shutdownport" ]
then
	echo "modifing the shutdown port..."
	sed -i "/shutdown/s;port=\"[^\"]*\";port=\"${shutdownport}\";" ${configfile} && echo -e "\tok. the shutdown port is ${shutdownport}" || echo failure.
fi

#如果指定了AJP1.3端口则修改它
if [ "$ajpport" ]
then
	echo "modifing the AJP1.3 port..."
	sed -i "/on port 8009/,/<!--/s;port=\"[^\"]*\";port=\"${ajpport}\";" ${configfile} && echo -e "\tok. the AJP1.3 port is ${ajpport}" || echo failure.
fi

