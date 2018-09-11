#!/bin/bash -
# 2018年 09月 12日 星期三 00:24:29 CST
# 重写此script
#
# df the mounted disk partitions

MESG=$(\df -h 2>/dev/null)

echo "$MESG" | head -n 1

#echo "$MESG" | grep ^/dev | sort -nk 1.9,2.0

echo "$MESG" | grep '^/dev'

unset MESG
