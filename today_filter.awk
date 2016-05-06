#!/usr/bin/awk -f

BEGIN{
    "date \"+%m %d\"" | getline;
    month=int($1)"月";
    day=int($2);
}
{
    if ($6 == month && $7 == day && index($8, ":")) {
        print
    }
}
