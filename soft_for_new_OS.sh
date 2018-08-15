#!/bin/bash -
# 2018年 08月 15日 星期三 15:29:19 CST
#新装debian 9时要装的软件
#2014年 07月 26日 星期六 18:04:42 CST

#日常使用, 美化, 维护
apt-get -y install aptitude
aptitude -y install numix-gtk-theme numix-icon-theme fonts-font-awesome zhcon goldendict fcitx fcitx-table-wubi smplayer vlc dia
#accountsservice可以抑制lightdm的一些错误
aptitude -y install accountsservice manpages-zh dos2unix tree ascii unrar autojump silversearcher-ag xbacklight \
                 tmux terminator deborphan \
                 zeitgeist arbtt

#网络
aptitude -y install mailutils openssh-server openssh-client lrzsz lftp fping traceroute \
                 curl aria2 axel w3m httpie youtube-dl \
                 atop htop iotop iftop nload

#开发相关
aptitude -y install cmake python-dev python-pip \
                 git gitk git-cola \
                 mysql-server mysql-workbench mycli \
                 libncurses5-dev libjpeg-dev \
                 nodejs cloc

# https://github.com/universal-ctags/ctags
# pip install ipython

#for vim插件
#pip install yapf isort flake8  #根据vim可识别python还是python3来选择是pip2还是pip3(echo has('python'))
aptitude -y install shellcheck

