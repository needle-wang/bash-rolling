#!/bin/bash -
# 用xbacklight在命令行中控制亮度
# 全局热键设置成 $0 -dec 和 $0 -inc
# 测试环境:
# ubuntu14.04, xfce4
# 2016年 05月 21日 星期六 17:48:32 CST
#
# 来自: http://forum.ubuntu.org.cn/viewtopic.php?p=3056691
# xbacklight -set 45 #xbacklight将屏幕亮度定义0到100的区间，0最暗，100最亮，这里设置为45
# xbacklight -dec 10 #降低10个百分点
# xbacklight -inc 10 #增加10个百分点
# xbacklight         #显示当前的屏幕亮度
# xbacklight -h      #打印帮助信息

test "${DISPLAY}" || exit 1

which xbacklight >/dev/null || {
    notify-send '找不到xbacklight'
    exit 1
}

XBACKLIGHT_CFG="${HOME}/.xbacklight.conf"
current_light=$(xbacklight)

if [[ "$1" ]]; then
    if [[ "${current_light}" ]]; then
        if [[ $(echo "${current_light}<=10" | bc) -eq 1 ]]; then
            if [[ "$1" == "-dec" ]]; then
                notify-send '已到可设置的最小亮度'
                exit 0
            fi
        elif [[ $(echo "${current_light}>=100" | bc) -eq 1 ]]; then
            if [[ "$1" == "-inc" ]]; then
                notify-send '已到最大亮度'
                exit 0
            fi
        fi
    fi

    xbacklight $1 10 && {
                            xbacklight > ${XBACKLIGHT_CFG}
                            notify-send "xbacklight $1 10"
                        }
else
    if [[ -s ${XBACKLIGHT_CFG} ]]; then
        xbacklight -set $(cat ${XBACKLIGHT_CFG})
    fi
fi
