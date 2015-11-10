#!/usr/bin/perl

$log='/var/log/kern.log';
$re='proc\b';

open IN,$log; @_=grep /$re/,<IN>; close IN;

if(@_<3){
   $log.=".1";
   open IN,$log; @_=grep /$re/,<IN>; close IN;
}
print "从 $log 读取开关机记录：\n";
#---------------------------------------
$lastday="";
for(@_){
   /(\w+\s+\w+)\s(\S+)/;
   $day=$1; $time=$2;
   $statu=/start/;
   if($day ne $lastday){
      $lastday=$day;
      $localday=`date -d "$day"`; $localday=~s/\s+\d\d\:.*//; chomp $localday;
      print "\n=====$localday=====\n";
   }
   if(/start/){print "$time -> ";}else{print "$time.\n";}
}
print "\n";
