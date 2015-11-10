#!/bin/bash -
log="/var/log/auth.log"
if [ "$1" ]
then
	log=$1
fi
echo "最近几次登陆失败信息："
IFS='\n'
for headline in $(tac ${log}| egrep 'Failed password for (\w+) from [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' |  tail -3)
do
echo ${headline}|awk '{print $1,$2,$3}' | paste - <(echo ${headline} | egrep -o 'Failed password for (\w+) from [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
done
echo "登陆失败统计信息："
cat ${log} | egrep -o 'Failed password for (\w+) from [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort | uniq -c | sort -rn

