#!/bin/bash -
# 抓取豆瓣电影列表(如科幻, 按评分排序)
# 如要修改, 改url应该就可以了.
# 
# 2018年 09月 21日 星期五 16:59:01 CST
# douban改版成js获取数据了, 搜索某部电影的功能失效了, 废弃
#  
# 2013/10/06 周日 05:50
# version2: 增加搜索列表及时间信息
# 以及完善减少修改量, 即智能化~
# 
# 2013/10/05 周六 03:36
# version1: 完成电影列表及top250
# by needle wang
#

#choose situation 1(电影列表) or 2(top250)
#若给出搜索关键字, flag标志将自动失效, 且只抓取一页
flag=1

#总共要抓取多少页
pageSum=1

if [ "${flag}" -eq "1" ]
then
	#situation1
	#喜剧列表，按评分排序
	#url_prefix='http://movie.douban.com/tag/%E5%96%9C%E5%89%A7?type=S&start='
	#科幻列表，按评分排序
	url_prefix='http://movie.douban.com/tag/%E7%A7%91%E5%B9%BB?type=S&start='
elif [ "${flag}" -eq "2" ]
then
	#situation2
	#豆瓣电影top250
	url_prefix='http://movie.douban.com/top250?filter=&format=&start='
fi


#situation3
#搜索电影, 根据是否给定搜索词自动判断
if [ "${1}" ]
then
	url_prefix='http://movie.douban.com/subject_search?cat=1002&search_text='
	#显示一页就够了
	pageSum=1
fi

#每页有多少条目: 搜索是15条, 列表是20条, top250是25条
if [ "${1}" ]
then
	onePageNum=15
elif [ "${flag}" -eq "1" ]
then
	onePageNum=20
elif [ "${flag}" -eq "2" ]
then
	onePageNum=25
else
	onePageNum=''
fi

#当前第几页，拼在url_prefix后面
pageIndex=0

#输出电影列表
printListOnePage(){	                  
#电影列表的匹配关键字
echo "$1" | tr '\n' ' ' | grep -oP '(?<=<div class="pl2">).*?(?=</div>)' | \
	while read i
	do
		name=$(echo "$i" | grep -oP '(?<=>).*(?=</a>)' | sed 's;<span.*">;;g;s;</span>;;g;s; ;;g' )
		score=$(echo "$i" | grep -oP '(?<="rating_nums">).*?(?=</span>)' )
		year=$(echo "$i" | egrep -o '[0-9]{4}(-[0-9]{2}){2}' | head -1 )
		test "${year}" && year="${year} "
		people=$(echo "$i" | grep -oP '(?<=<span class="pl">)(.*)(?=</span)' )
		echo "${score:=none}${people} ${year}${name}"
	done
}

#输出top250列表
printTop250OnePage(){
#top250的匹配关键字与电影列表不一样
#html格式也不一样，要改成一行
echo "$1" | tr '\n' ' ' | grep -oP '(?<=<div class="info">).*?inq.*?(?=</div>)' | \
	while read i
	do
		name=$(echo "$i" | grep -oP '<a.*a>' | sed 's/<[^>]*>//g;s/^ *//g;s/&nbsp;/ /g' | tr -s ' ' )
		score=$(echo "$i" | grep -oP '(?<=<em>).*?(?=</em>)' )
		year=$(echo "$i" | egrep -o '[0-9]{4}&nbsp;/' | head -1 )
		people=$(echo "$i" | grep -oP '(?<=<span>).*?(?=</span>)' )
		echo "${score:=none}(${people}) ${year/&nbsp;\// }${name}"
	done
}

#输出搜索结果列表
printSearchOnePage(){
#匹配关键字与电影列表的相似, 但是:
#1.改成文本源转换成一行, 2.name的正则要改成top250的;
echo "$1" | tr '\n' ' ' | grep -oP '(?<=<div class="pl2">).*?(?=</div>)' | \
	while read i
	do
		name=$(echo "$i" | grep -oP '<a.*a>' | sed 's/<[^>]*>//g;s/^ *//g;s/&nbsp;/ /g' | tr -s ' ' )
		score=$(echo "$i" | grep -oP '(?<="rating_nums">).*?(?=</span>)' )
		year=$(echo "$i" | egrep -o '[0-9]{4}(-[0-9]{2}){2}' | head -1 )
		test "${year}" && year="${year} "
		people=$(echo "$i" | grep -oP '(?<=<span class="pl">)(.*)(?=</span)' )
		echo "${score:=none}${people} ${year}${name}"
	done
}

trap "echo '中断';exit 1" INT
for ((count=0; count<pageSum; count++))
do
	if [ "${1}" ]
	then
		#拼接 要搜索的 电影关键词
		url="${url_prefix}${1}"
	else
		url="${url_prefix}${pageIndex}"
	fi
	echo "--------- url is ${url} ---------"

	oneContent=$(wget -q "${url}" -O - )
  #echo "$oneContent"

	if [ "${1}" ]
	then
		printSearchOnePage "${oneContent}"
	else
		if [ "${flag}" -eq "1" ]
		then
			printListOnePage "${oneContent}"
		elif [ "${flag}" -eq "2" ]
		then
			printTop250OnePage "${oneContent}"
		else
			echo "setting is not clear~~~"
			exit 1
		fi
	fi

	pageIndex=$((${pageIndex}+${onePageNum}))
done

