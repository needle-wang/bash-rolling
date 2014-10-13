#!/bin/bash -

#显示当前目录下的隐藏目录和文件
#无参数

ls -AlFhrt | awk '{if(index($9,".")==1) print $0 }'
