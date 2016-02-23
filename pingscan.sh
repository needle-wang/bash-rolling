#!/bin/bash -
#
#2014年 12月 28日 星期日 18:24:19 CST

netPrefix='192.168.1.'

if [[ "$1" == "-h" ]]; then
    echo -e "usage: $0 [netPrefix]\n$0 or $0 192.168.1."
    exit 0
elif [[ "$1" ]]; then
    netPrefix="$1"
fi

echo "all online ip in ${netPrefix}1/24 by ping:"
#only add the ps when debug, the ctrl-c appears normal...
#trap "ps -o pid,cmd | egrep ' pin[g] '|egrep -o '^[0-9]*'; exit 0" INT
trap "ps -o pid,cmd | sed -n ''; exit 0" INT
#trap "sleep 1s; echo 'terminated manually.'; exit 0" INT
for i in $(seq 1 254)
do
	{
		ping -qc2 ${netPrefix}${i} >/dev/null
		if [ "$?" -eq "0" ]
		then
            lan_ip=$(ip -o address | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v "${netPrefix}255|127.0.0.1")
            if [[ "${netPrefix}${i}" == ${lan_ip} ]]; then
                local_lan_ip='(self)'
            fi
            echo -e "${netPrefix}${i}${local_lan_ip}"
		fi
	}&
done

wait

#alive_host=$(fping -a -g 192.168.0.2 192.168.0.200 2>/dev/null)

#for i in ${alive_host}
#do
#	echo $i
#done

