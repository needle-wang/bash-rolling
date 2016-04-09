#!/bin/bash -
# 用amixer在命令行中控制音量
# 建议 ${1}设为4到5之间的值吧
# 测试环境:
# ubuntu14.04, xfce4
#2016年 04月 09日 星期六 21:58:07 CST

#判断是否为整数
[[ "${1}" =~ ^-?[0-9]+$ ]] || exit 1

#amixer:
#scontrols: show all mixer simple controls(就是声音控制器列表, 如Master, headphone等)
#scontents: show contents of all mixer simple controls(default)(显示控制器的信息)

#sset sID P set contents for one mixer simple control
#sget sID   get contents for one mixer simple control

#controls: 看不懂, 没用不要管
#contents: 看不懂, 没用不要管
#cget/cset: 不要管~

#例子:
#amixer -c 1 -- sset Master playback -20dB
#-c: 设定要显示信息的声卡序号
#在amixer里不知道怎么打印声卡列表, 可以alsamixer中按<F6>查看
#在y430p, xfce中声卡是HDA Intel PCH(序号为1)

current_volume=$(amixer -c 1 -- sget Master | tail -n 1 | awk '{print $5}' | egrep -o -- '-?[0-9]+\.?[0-9]*')
new_volume=$(echo "${current_volume}+${1}" | bc)

#Master分贝域为[-65.25, 0.00](-65.25dB为最小值, 0.00dB为最大值)
#再小就会调另一个声音控制器: headphone(如果戴耳机的话)
if [[ $(echo "${new_volume}>=0.00" | bc) -eq 1 ]]; then
    new_volume=0.00
    notify-send 'Master音量已到最大'
fi

if [[ $(echo "${new_volume}<=-65.25" | bc) -eq 1 ]]; then
    new_volume=-65.25
    notify-send 'Master音量已到最小'
fi

amixer -c 1 -- sset Master playback ${new_volume}dB

