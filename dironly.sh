#!/bin/bash -
#只显示目录，加-a则显示所有目录(包括隐藏)
#用法：onlyDir.sh [-a]
#2016年 04月 12日 星期二 15:48:17 CST


#参数数量
if [ $# -gt 1 ]
then
	echo "usage: $0 [-a]"
	exit 1
fi

if [ $# -eq 1 ]
then
	case $1 in
	-a|-all|--all)
        ls -AFrt | grep '/$' | sed 's;/$;;g' | xargs -I{} ls -ldFh --color=auto {}
		exit 0
		;;
	*)
        echo "usage: $0 [-a]"
		exit 1
		;;
	esac
fi


# ls嵌套竟然不支持空格目录~
# ls -d $(ls -dQ a\ b)      #failed
#xargs里的ls还不支持 按时间排序~
ls -drt */ 2> /dev/null | sed 's;/$;;g' | xargs -I{} ls -ldFh --color=auto {}

#随便加的~
exit 0
