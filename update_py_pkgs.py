#!/usr/bin/env python
# encoding: utf-8
#2018年 06月 06日 星期三 00:18:45 CST
#改成使用pip V10版本
#2016年 03月 04日 星期五 17:19:41 CST
#一次更新所有python包, need sudo, of course!
#http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip

import pip
# pip V10.0.0以上版本需要导入下面的包
from pip._internal.utils.misc import get_installed_distributions
from subprocess import call

def main():
  # 执行后，pip默认为Python3版本
  # 双版本下需要更新Python2版本的包，使用py2运行，并将pip修改成pip2
  for dist in get_installed_distributions():
    call('sudo -H pip install -U -i https://pypi.tuna.tsinghua.edu.cn/simple ' +
        dist.project_name, shell = True)

if __name__ == '__main__':
  main()
