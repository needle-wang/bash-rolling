#!/bin/bash -
#查看vim的vundle管理的插件的git status
#2016年 03月 18日 星期五 15:05:52 CST

cur="$HOME/.vim/bundle"

if [[ "$1" ]]; then
  cur=$1
fi

cd $cur || exit 1

cur=$(pwd)
for i in *
do
  gitname=${cur}/${i}
  cd ${gitname} || continue

  result=$(git status)

  if echo "${result}" | grep -q "干净的工作区"; then
      if echo "${result}" | grep -q "一致"; then
          continue
      fi
  fi
  echo -e "\033[32m----- ${gitname} -----\033[0m"
  echo "${result}"
  echo
done

