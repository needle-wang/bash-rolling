#!/bin/bash -
# 
# 2018年 08月 14日 星期二 02:00:13 CST
# debian9 xfce4: 
# synclient不能禁用touchpad的按键
# 用xfce4自带的设置编辑器(xfconf-query), 前端GUI是设置管理器 
# 在 设置管理器-鼠标和触摸板-设备 中可以看到设置的效果

key_path='/SynPS2_Synaptics_TouchPad/Properties/Device_Enabled'
sign=$(xfconf-query -c pointers -p "$key_path")

if [[ "$sign" == "0" ]]; then
  xfconf-query -c pointers -p "$key_path" -n -t int -s 1 && echo '触摸板被启用.'
else
  xfconf-query -c pointers -p "$key_path" -n -t int -s 0 && echo '触摸板被禁用.'
fi


#此为触摸板开关.
#若想开机禁用, 需要在~/.profile(因为只在login shell加载)里禁用.
#touchpadoff不是fn+F7, 相当于总开关, 而fn+f7算小开关
#2014年 03月 25日 星期二 04:39:24 CST

#0为打开触摸板, 1为关闭
#touchpadoff=[0|1]

#sign=$(synclient |awk '{if($1 == "TouchpadOff"){print $3}}')

#if [ "${sign}" == "0" ]; then
	#synclient touchpadoff=1 && echo '触摸板被禁用.'
#else
	#synclient touchpadoff=0 && echo '触摸板被启用.'
#fi

