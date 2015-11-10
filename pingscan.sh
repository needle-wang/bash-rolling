#!/bin/bash -
#
#2014年 12月 28日 星期日 18:24:19 CST

netPrefix='192.168.1.'

for i in $(seq 1 254)
do
	{
		ping -qc2 ${netPrefix}${i} >/dev/null
		if [ "$?" -eq "0" ]
		then
			echo -e "$netPrefix$i\tis alive"
		fi
	}&
done

wait

#alive_host=$(fping -a -g 192.168.0.2 192.168.0.200 2>/dev/null)

#for i in ${alive_host}
#do
#	echo $i
#done

