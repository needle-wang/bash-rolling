#!/bin/bash -
# 2018年 08月 15日 星期三 15:29:19 CST
#新装debian 9时要装的软件
#2014年 07月 26日 星期六 18:04:42 CST

#日常使用, 美化, 维护
apt-get -y install aptitude deborphan
aptitude -y install numix-gtk-theme numix-icon-theme fonts-wqy-microhei fonts-wqy-zenhei fonts-symbola fonts-font-awesome \
                    fcitx fcitx-table-wubi goldendict smplayer vlc dia
#accountsservice可以抑制lightdm的一些错误
aptitude -y install accountsservice manpages-zh dos2unix tree ascii unrar unzip p7zip autojump silversearcher-ag xbacklight \
                    zhcon tmux terminator \
                    arbtt #trash-cli

#网络
aptitude -y install mailutils openssh-server openssh-client lrzsz lftp fping traceroute \
                    curl aria2 axel w3m httpie youtube-dl \
                    atop htop iotop iftop nload

#开发相关
aptitude -y install cmake python-dev python-pip \
                    git gitk git-cola \
                    mysql-server mysql-workbench mycli \
                    libncurses5-dev libjpeg-dev \
                    cloc #代码行数统计(类似于wc -l)

# for nodejs
# https://github.com/nodesource/distributions
# https://docs.npmjs.com/
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
aptitude -y install nodejs
# apt-get install build-essential(包含gcc g++ make)  # for native addons

# https://github.com/universal-ctags/ctags
# pip install ipython

#for vim插件
#pip install yapf isort flake8  #根据vim可识别python还是python3来选择是pip2还是pip3(echo has('python'))
aptitude -y install shellcheck

