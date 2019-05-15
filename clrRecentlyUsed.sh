#!/bin/bash -
#清空ubuntu最近文档的记录
#gnome与unity的recently-used.xbel位置不一样
#2012-5-9补充unity的，偶然发现的，没想到名字没变。

#在gnome里的位置
base="$HOME"

record="$base/.recently-used.xbel"

if [ ! -e "$record" ];
then
	#unity里的位置
	record="$base/.local/share/recently-used.xbel"
fi

printf '<?xml version="1.0" encoding="UTF-8"?>
<xbel version="1.0"
      xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks"
      xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info"></xbel>' >"$record"

