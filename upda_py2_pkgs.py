#!/usr/bin/env python2
# encoding: utf-8
# 2018年 08月 28日 星期二 13:58:45 CST
# python2应该调用pip2, 不要换成调用pip3, 否则两py版本的包会同质掉
# 增加print
# 2018年 06月 06日 星期三 00:18:45 CST
# 改成使用pip V10版本
# 2016年 03月 04日 星期五 17:19:41 CST
# 一次更新所有python包, required: sudo(certainly)
# http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip

import sys
from subprocess import call

import pip
# pip V10.0.0以上版本需要导入下面的包
from pip._internal.utils.misc import get_installed_distributions


def main():
  print('deprecated since python2 was gone.')
  return
  # print('python版本: %s' % sys.version)
  use_proxy = '-i https://pypi.tuna.tsinghua.edu.cn/simple'
  for dist in get_installed_distributions():
    _msg = '[{}: {}]: '.format(dist.project_name, dist.location)
    if 'local' in dist.location:
      print(_msg)
      call('sudo -H pip2 install -U %s %s' % (use_proxy, dist.project_name),
           shell=True)
    else:
      # 说明此包使用的是apt-get install python-* 形式安装的
      # 由于python2已停更, 所以python2的包应尽量保持最小化
      print('{}\tinstalled by OS, ignore...'.format(_msg))


if __name__ == '__main__':
  main()
