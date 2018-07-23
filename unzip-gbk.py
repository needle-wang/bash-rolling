#!/usr/bin/env python
# -*- coding: utf-8 -*-
# unzip-gbk.py

import os
import sys
import threading
import zipfile


def unzip(a_zip_filename, coding='gbk'):
  with zipfile.ZipFile(a_zip_filename, "r") as a_zip:
    for name in a_zip.namelist():
      a_filepath_unicode = name.decode(coding)
      # 正常逻辑是, 不要额外添加同名目录
      # 但如果根级有很多文件, 解压后会在当前目录散开成一片
      # 而写成添加同名目录, 又有可能根级只有一个: 同名目录~
      # 而要判断是否只有一个目录, 又要对全列表解析, 大zip文件会增加庞大开销~
      # a_filepath_unicode = os.path.join(a_zip_filename[:-4], a_filepath_unicode)

      the_dir = os.path.dirname(a_filepath_unicode)

      if the_dir and not os.path.exists(the_dir):
        os.makedirs(the_dir)  # mkdir -p the_dir
        if a_filepath_unicode.endswith('/'):  # 刚建的新目录条目, continue
          continue

      # 对于第二次解压: 要写成默认不覆盖吗?
      if os.path.exists(a_filepath_unicode):
        print('ignore existed file: %s in %s' %
              (a_filepath_unicode.encode('utf8'), a_zip_filename))
        continue

      with open(a_filepath_unicode, "w") as fo:
        data = a_zip.read(name)
        fo.write(data)


def unzips(a_zip_list, is_single_thread=False):
  threads = []
  for a_zip_filename in a_zip_list:
    if zipfile.is_zipfile(a_zip_filename):
      if is_single_thread:
        unzip(a_zip_filename)
      else:
        threads.append(threading.Thread(target=unzip, args=(a_zip_filename, )))
    else:
      print('"%s" should: existed, is_zip, r--' % a_zip_filename)

  for t in threads:
    # t.setDaemon(True)     #文件操作不能设守护进程, 主进程死亡, 没有std*之类的资源肯定出错
    t.start()


def main():
  unzips(sys.argv[1:])


if __name__ == '__main__':
  main()
