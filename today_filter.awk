#!/usr/bin/awk -f

BEGIN{
    "date \"+%-m月 %-d\"" | getline;
    month=$1;
    day=$2;
}
{
    if ($6 == month && $7 == day && index($8, ":")) {
        print
    }
}
