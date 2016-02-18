#!/bin/bash -

#显示文件最后一行内容
#用法：printLastLine.sh filename

sed -n '$p' "$1"
