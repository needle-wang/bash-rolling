#!/bin/bash -
#��Ҫ����,��Ŀ¼������ͼƬ����Ŀ¼��Ϊǰ׺
#version1:2011-8-29

dir=$(basename "${PWD}")

for i in *.jpg
do
    mv ${i} ${dir}_${i}
done
