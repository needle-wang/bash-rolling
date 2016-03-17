#!/usr/bin/env python
# encoding: utf-8
#一次更新所有python包, need sudo, of course!
#http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip
#2016年 03月 04日 星期五 17:19:41 CST

import pip
from subprocess import call

def main():
    for dist in pip.get_installed_distributions():
        call('sudo -H pip install --upgrade ' + dist.project_name, shell =True)

if __name__ == '__main__':
    main()

