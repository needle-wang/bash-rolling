#!/bin/bash -
# 2018年 08月 15日 星期三 15:29:19 CST
# 新装debian 9时要装的软件
# 2014年 07月 26日 星期六 18:04:42 CST

# 日常使用/美化/维护
apt-get -y install aptitude synaptic deborphan gtkorphan
# ttf-mscorefonts-installer包: 该安装器会下载win下的核心字体, fonts-liberation包是win下核心字体的变体
aptitude -y install numix-gtk-theme numix-icon-theme \
                    fonts-ubuntu fonts-ubuntu-console \
                    fonts-wqy-microhei fonts-wqy-zenhei \
                    fonts-symbola fonts-font-awesome \
                    fcitx fcitx-frontend-qt5 fcitx-table-wubi goldendict orage smplayer vlc
# accountsservice可以抑制lightdm的一些错误, 别装locate, 应该装mlocate
# xbacklight terminator tmux byobu arbtt trash-cli
aptitude -y install accountsservice manpages-zh mlocate dos2unix tree ascii unrar unzip p7zip zhcon \
                    atop htop iftop iotop nload multitail \
                    autojump silversearcher-ag

# github:
  # cat增强
  # https://github.com/sharkdp/bat
  # grep增强, 目前还没进LTS的官方ppa, 还是暂时用ag吧
  # https://github.com/BurntSushi/ripgrep
  # 以下, 都没什么实际用处
  # find增强, mlocate多好用, catfish后端也用的mlocate
  # https://github.com/sharkdp/fd
  # 配合find使用, 对结果列表进一步过滤, 通过模糊查找的方式
  # https://github.com/junegunn/fzf

# 网络
# openssh-server
aptitude -y install dnsutils mailutils openssh-client lrzsz lftp fping traceroute \
                    curl aria2 axel w3m youtube-dl \
                    kcptun privoxy

# 开发相关
# 使用get-pip.py文件 安装pip3
# automake, build-essential(包含gcc g++ make), cmake: 用于编译, 必备的!
aptitude -y install automake build-essential cmake\
                    git gitk git-cola \
                    mycli jq cloc # 代码行数统计(类似于wc -l)
                    # mysql-server mysql-workbench \
                    # libncurses5-dev libjpeg-dev \
                    # python3-tk

# https://github.com/universal-ctags/ctags
# 需要automake编译, 详见github上的源码里的docs/autotools.rst

sudo pip3 install httpie ipython

#for vim插件: echo has('python3')
# 1. sudo pip3 install isort yapf flake8
# 或:
# 2. apt install isort yapf3 flake8 # python3-isort/yapf/flake8没有bin文件 
aptitude -y install isort yapf3 flake8 shellcheck

# for nodejs
# https://github.com/nodesource/distributions
# https://docs.npmjs.com/
#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#aptitude -y install nodejs

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
