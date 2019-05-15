#!/bin/bash -
# 2018年 08月 15日 星期三 15:29:19 CST
# 新装debian 9时要装的软件
# 2014年 07月 26日 星期六 18:04:42 CST

# 日常使用, 美化, 维护
apt-get -y install aptitude deborphan gtkorphan
aptitude -y install numix-gtk-theme numix-icon-theme fonts-wqy-microhei fonts-wqy-zenhei fonts-symbola fonts-font-awesome \
                    fcitx fcitx-table-wubi goldendict smplayer vlc
# accountsservice可以抑制lightdm的一些错误, 别装locate, 应该装mlocate
# xbacklight terminator tmux byobu arbtt trash-cli
aptitude -y install accountsservice manpages-zh mlocate dos2unix tree ascii unrar unzip p7zip zhcon autojump silversearcher-ag

# github:
  # cat增强
  # https://github.com/sharkdp/bat
  # grep增强, 目前还没进LTS的官方ppa, 还是暂时用ag吧
  # https://github.com/BurntSushi/ripgrep
  # find增强, mlocate多好用, catfish后端也用的mlocate
  # https://github.com/sharkdp/fd

# 网络
# openssh-server
aptitude -y install dnsutils mailutils openssh-client lrzsz lftp fping traceroute \
                    curl aria2 axel w3m youtube-dl \
                    kcptun polipo \
                    atop htop iotop iftop nload
sudo pip3 install httpie

# 开发相关
# 安装pip和pip3, 并升级, 然后卸载python*-pip
aptitude -y install cmake python-dev python-pip python3-pip \
                    git gitk git-cola \
                    mysql-server mysql-workbench mycli \
                    libncurses5-dev libjpeg-dev \
                    jq cloc # 代码行数统计(类似于wc -l)
                    # python-tk python3-tk

# for nodejs
# https://github.com/nodesource/distributions
# https://docs.npmjs.com/
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
aptitude -y install nodejs
# apt-get install build-essential(包含gcc g++ make)  # for native addons

# https://github.com/universal-ctags/ctags
# pip3 install ipython

#for vim插件
#pip3 install yapf isort flake8  #根据vim可识别python还是python3来选择是pip2还是pip3(echo has('python'))
aptitude -y install shellcheck

# 关于debian9下的goldendict(建议使用qt5版本)
# 使用qt4的版本时(aptitude show goldendict), 会有 hotkey上输入框 的bug, 且界面字体过小(高分屏)
# 0.安装qt5
# aptitude -y install qt5-default
# 源码编译: https://github.com/goldendict/goldendict
# 1.
# sudo apt-get install pkg-config build-essential qt5-qmake \
#     libvorbis-dev zlib1g-dev libhunspell-dev x11proto-record-dev \
#     qtdeclarative5-dev libqtwebkit-dev libxtst-dev liblzo2-dev libbz2-dev \
#     libao-dev libavutil-dev libavformat-dev libtiff5-dev libeb16-dev \
#     libqt5webkit5-dev libqt5svg5-dev libqt5x11extras5-dev qttools5-dev \
#     qttools5-dev-tools qtmultimedia5-dev libqt5multimedia5-plugins \
#     libopencc-dev
# 2.
# git clone git://github.com/goldendict/goldendict.git
# 3.
# cd goldendict && sudo make distclean
# 4.
# qmake "CONFIG+=old_hunspell" "CONFIG+=chinese_conversion_support"
# 5.
# make
# 6.
# sudo make install
# 7.问题是, 安装完后, 这些编译时用到的库, 不能autoremove~, 该不该清理掉?
