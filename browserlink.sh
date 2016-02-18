#!/bin/bash -
#run browserlink for editing html
#2015年 12月 05日 星期六 17:12:35 CST

if [ -f /usr/bin/node ]; then
    cd ~/.vim/bundle/browserlink.vim/browserlink && ./start.sh
else
    echo "can't find command: node"
fi

