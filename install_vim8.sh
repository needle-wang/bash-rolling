#!/bin/echo you must know what you are doing.
# install vim8.1.
#
# by needle wang
# 2018年 08月 15日 星期三 01:16:36 CST
# https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# 2015年 01月 09日 星期五 03:52:51 CST
# recomplete it.
# 2013年 08月 31日 星期六 15:22:54 CST
# well done in 12.04, 14.04.

echo "must be in vim8's sourcecode dir"
read -p "make sure?"

sudo make distclean

#sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev ruby-dev liblua5.1 lua5.1-dev libperl-dev
# 在第一次安装之前要确保系统满足安装需要的依赖:
# apt-get build-dep vim   #此行已废弃, 不再需要

# 好像即使是vim8也不能同时支持python和python3~
#./configure --enable-gui=gtk3从没安装成功过~

./configure --with-features=huge --enable-python3interp=yes --enable-rubyinterp=yes --enable-perlinterp=yes --enable-luainterp=yes --enable-cscope --enable-gui=auto --with-x --enable-fontset --enable-multibyte --enable-xim --with-compiledby=needlewang2011@gmail.com

if [ "$?" -eq "0" ]
then
	#-j3是不是指三个线程(job)?，whatever, it's not bad.
	make -j3
fi

if [ "$?" -eq "0" ]
then
	sudo make install 
fi

echo "the final status code is $?"

