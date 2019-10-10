#!/usr/bin/env python3
# encoding: utf-8
#
# 2019年 10月 11日 星期五 04:10:44 CST
# https://gist.github.com/hideaki-t/c42a16189dd5f88a955d

import os
import sys
import threading
import zipfile
from pathlib import Path


def unzip(filename, encoding='gbk', v = False):
  with zipfile.ZipFile(filename) as z:
    namelist = z.namelist()
    if len(namelist) > 1:
      cwd = Path(Path(filename).stem)
      if not cwd.exists():
        cwd.mkdir()

      os.chdir(cwd)

    for _ in namelist:
      _path = Path(_.encode('cp437').decode(encoding))
      if v:     # 打印解压过程中的文件名
        print(_path)
      # 如果是目录
      if _[-1] == '/':
        if not _path.exists():
          _path.mkdir()
      else:
        with _path.open('wb') as w:
          w.write(z.read(_))


def unzips(zip_list, is_single_thread=False):
  threads = []
  for a_zip in zip_list:
    if zipfile.is_zipfile(a_zip):
      if is_single_thread:
        unzip(a_zip)
      else:
        threads.append(threading.Thread(target=unzip, args=(a_zip, )))
    else:
      print('"%s" should: existed, is_zip, r--' % a_zip)

  for t in threads:
    t.start()


def main():
  unzips(sys.argv[1:])


if __name__ == '__main__':
  main()
