#!/bin/bash -
#打印指定文件的全路径名
#2014年 10月 23日 星期四 17:17:14 CST

test "$1" || {
        echo -e "need a filepath:\n$0 filename or filename_with_part_of_path"
        exit 1
    }

cd $(dirname "$1")
filename=$(basename "$1")
echo $(pwd)/${filename}

