#!/usr/bin/awk -f
#函数要定义在大括号外,
#变量要定义在大括号内, 且跟shell一样 不定义也可以使用~
#2016年 03月 17日 星期四 17:39:29 CST

function readable(num, count){
    if(num < 1 && count == 0){
        return num""output_unit[count]
    } else {
        if(num < 1 && count > 0){
            return readable(num * 1024, count - 1)
        } else {
            if(num < 1024){
                return num""output_unit[count]
            } else {
                if(count == 4){
                    return num""output_unit[count]
                }
                return readable(num / 1024, count + 1)
            }
        }
    }
}

{
    if($1 ~ /^-/){
        exit 1
    }
    output_unit[0] = ""
    output_unit[1] = "K"
    output_unit[2] = "M"
    output_unit[3] = "G"
    output_unit[4] = "T"

    if($1 ~ /[kmgtKMGT]$/){
        gsub(",", "", $1)
        #要强制转换成数字, 不然转换里与1024的判断实际是字串, 会与实际不符
        num = substr($1, 1, length($1)-1) + 0
        old_unit = toupper(substr($1,length($1)))

        for(i = 0; i in output_unit; i++){
            if(output_unit[i] == old_unit){
                count = i
            }
        }
        $1 = readable(num, count)
    } else {
        $1 = readable($1, 0)
    }
    print 
}
