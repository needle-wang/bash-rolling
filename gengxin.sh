#!/bin/bash -
# 2020年 05月 16日 星期六 01:16:54 CST

trap "echo -e '\n手动中断...';exit 1" INT
#LANG=C 

if which apt-fast > /dev/null; then
  APT='sudo apt-fast'
else
  APT='sudo apt-get'
fi

if [[ "$1" ]]; then
  PROXY="-c \"$HOME/bin/apt-proxy.conf\""
else
  PROXY=""
fi

$APT update -y
$APT dist-upgrade -y "$PROXY"

echo -e '\n2秒后 进行apt autoclean, 按任意键取消...\n'

if ! read -rt 2; then
  $APT autoremove
  $APT autoclean
  $APT clean
  sudo updatedb
fi

