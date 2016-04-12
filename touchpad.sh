#!/bin/bash -
#此为触摸板开关.
#若想开机禁用, 需要在~/.profile(因为只在login shell加载)里禁用.
#touchpadoff不是fn+F7, 相当于总开关, 而fn+f7算小开关
#2014年 03月 25日 星期二 04:39:24 CST

#0为打开触摸板, 1为关闭
#touchpadoff=[0|1]

sign=$(synclient |awk '{if($1 == "TouchpadOff"){print $3}}')

if [ ${sign} -eq 0 ]; then
	synclient touchpadoff=1 && echo '触摸板被禁用.'
else
	synclient touchpadoff=0 && echo '触摸板被启用.'
fi

