#!/bin/echo you must know what you are doing.
#install vim74/vim8 to needle's as4750g.
#
#by needle wang
#2015年 01月 09日 星期五 03:52:51 CST
#recomplete it.
#2013年 08月 31日 星期六 15:22:54 CST
#well done in 12.04, 14.04.

echo "must be in vim74/vim8's sourcecode dir"
read -p "make sure?"

sudo make distclean

#在第一次安装之前要确保系统满足安装需要的依赖:
#apt-get install libncurses5-dev
#apt-get build-dep vim

#不要加python3! 有的vim的插件不会识别python\dyn形式
#详见http://zengrong.net/post/1690.htm
#--enable-python3interp=yes 

./configure --with-features=huge --enable-pythoninterp=yes --enable-rubyinterp=yes --enable-perlinterp=yes --enable-luainterp=yes --enable-cscope --enable-gui=auto --with-x --enable-fontset --enable-multibyte --enable-xim --with-compiledby=needlewang2011@gmail.com

if [ "$?" -eq "0" ]
then
	#-j3是不是指三个线程(job)?，whatever, it's not bad.
	make -j3
fi

if [ "$?" -eq "0" ]
then
	sudo make install 
fi

echo the run status code is $?

