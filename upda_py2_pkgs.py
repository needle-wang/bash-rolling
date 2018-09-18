#!/usr/bin/env python2
# encoding: utf-8
# 2018年 08月 28日 星期二 13:58:45 CST
# python2应该调用pip2, 不要换成调用pip3, 两py版本的包会同质掉
# 增加print
# 2018年 06月 06日 星期三 00:18:45 CST
# 改成使用pip V10版本
# 2016年 03月 04日 星期五 17:19:41 CST
# 一次更新所有python包, required: sudo(of course!)
# http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip

import sys
from subprocess import call

import pip
# pip V10.0.0以上版本需要导入下面的包
from pip._internal.utils.misc import get_installed_distributions


def main():
  # print('python版本: %s' % sys.version)
  for dist in get_installed_distributions():
    print('[%s: %s]' % (dist.project_name, dist.location))
    if 'local' in dist.location:
      call(
        'sudo -H pip2 install -U -i https://pypi.tuna.tsinghua.edu.cn/simple ' +
        dist.project_name,
        shell=True)
    else:
      # 说明此包使用的是apt-get install python-* 形式安装的
      # 由于不推荐使用python2, 所以python2的包尽量保持最小化
      print('    installed by OS, I think it is better not to upgrade.')
    print('-------华丽的分割线-------')


if __name__ == '__main__':
  main()