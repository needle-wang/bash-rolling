#!/bin/bash -
#QQ空间信息接口
#可查看任何QQ的空间说说日志条信息
#注:可能~, 不是任何人的…
#2013年 10月 19日 星期六 22:53:51 CST

LANG=zh_CN.UTF-8

echo "$1" | grep -q '^[0-9]\+$' || exit 1


url_prefix='http://snsapp.qzone.qq.com/cgi-bin/qzonenext/getplcount.cgi?hostuin='"$1"

mesg=$(wget -qO - $url_prefix)
mesg=$(echo "$mesg" | sed 's/^_Callback({//;s/});$//')
mesg=$(echo "$mesg" | sed 's;},;}\n;' | sed 's/{/{\n/;s/}/\n/')

mesg=$(echo "$mesg" | tr ',' '\n')
mesg=$(echo "$mesg" | sed 's;"LY";留言;')
mesg=$(echo "$mesg" | sed 's;"LYSH";留言审核;')
mesg=$(echo "$mesg" | sed 's;"PYSS";评论说说;')
mesg=$(echo "$mesg" | sed 's;"RZ";日志;')
mesg=$(echo "$mesg" | sed 's;"RZSH";日志审核;')
#漏一条翻译，不知道翻成什么
#mesg=$(echo "$mesg" | sed 's;"SCR";???;')
mesg=$(echo "$mesg" | sed 's;"SS";说说;')
mesg=$(echo "$mesg" | sed 's;"SSSH";说说审核;')
mesg=$(echo "$mesg" | sed 's;"XC";相册;')
mesg=$(echo "$mesg" | sed 's;"XCSH";相册审核;')

mesg=$(echo "$mesg" | sed 's;"msg";未读信息;')

#去掉多余的行
mesg=$(echo "$mesg" | sed '/"count"/d')
mesg=$(echo "$mesg" | sed '/"result"/d')
mesg=$(echo "$mesg" | sed '/"now"/d')
mesg=$(echo "$mesg" | sed '/"code"/d')

date
echo "$mesg"

