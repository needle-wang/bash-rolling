#!/bin/bash -

#只显示目录，加-a则显示所有目录(包括隐藏)
#用法：onlyDir.sh [-a]


if [ $# -gt 1 ]
then
	echo '用法：onlyDir.sh [-a]'
	exit 1
fi

if [ $# -eq 1 ]
then
	case $1 in
	-a|-all|--all)
		ls -AlFhrt | grep ^d | awk '{print $0}'
		exit 0
		;;
	*)
		echo '用法：onlyDir.sh [-a]'
		exit 1
		;;
	esac
fi

ls -AlFhrt | grep '^d' | awk '{print $0}' | sort

#随便加的~
exit 0


