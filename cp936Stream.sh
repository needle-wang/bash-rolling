#/usr/bin/bash -
#cygwin下使用win命令的输出为cp936编码，在cygwin的utf-8环境中为乱码
#特写此脚本，用来转换GBK编码流
#虽然在.bashrc里写成alias形式更方便一些~
#用法如：arp -a|cp936Stream
#2012-7-4

iconv -f CP936 -t UTF-8

