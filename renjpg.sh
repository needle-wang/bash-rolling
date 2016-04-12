#!/bin/bash -
#不要参数,将目录下所有图片名加目录名为前缀
#version1:2011-8-29

dir=$(basename "${PWD}")

for i in *.jpg
do
    mv ${i} ${dir}_${i}
done
