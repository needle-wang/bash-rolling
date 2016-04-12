#!/bin/bash -
#显示当前目录下的隐藏目录和文件
#无参数
#
#2016年 04月 12日 星期二 16:42:43 CST
#refact.
#使ls的颜色有显示

#ls -AlFhrt | awk '{if(index($9,".")==1) print $0 }'

ls -drt .* | grep -v '^\.\.\?$' | xargs -I{} ls -ldFh --color=auto {}
