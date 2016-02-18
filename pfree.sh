#!/bin/bash -
#列出进程占用的固有内存
#练习了getopt命令(支持长选项和乱序但复杂,而getopts不支持前述两者)
#getopts有snip片段
#by needle
#2014年 07月 19日 星期六 01:06:02 CST
#version 0.2
#when grep one_keyword, add the mesg of head line (ps's first line)
#grep use '--color=auto' and '--' option
#improve the help mesg.
#2014年 05月 03日 星期六 17:04:07 CST
#wrote version 0.1

LANG=zh_CN.UTF-8

__ScriptVersion="0.2"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
usage ()
{
		cat <<- EOT

  format like pgrep. print rss of processes based on name.
  Usage :  $0 [options] [--] [one_keyword_to_grep]

  Options:
  -h|--help       Display this message
  -v|--version    Display script version
  -a|--all        Display the detail of all requested processes

		EOT
}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

args=$(getopt -o "hva" --long help,version,all -- "$@")

#重排参数，不大明白eval在此的意义，而且是一定要
eval set -- "$args"

while true
do
  case $1 in

	-h|--help     )  usage; exit 0   ;;

	-v|--version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	-a|--all      )  list_all_flag=true; shift 1   ;;

    --            )  shift; break   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
#shift $(($OPTIND-1))

ps_list=$(ps uax --sort rss)

#show the one_keyword_to_grep's result
if [[ "$list_all_flag" ]]; then
    #如果存在关键字, 确保输出首行
    if [[ "$1" ]]; then
         echo "$ps_list" | head -n 1
    fi
    echo "$ps_list" | grep --color=auto -- "$1"
fi

#show the total of rss
echo "$ps_list" | grep --color=auto -- "$1" | awk '{i+=$6}END{print "total(rss):",i/1024"M"}'

