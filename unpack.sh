#!/bin/bash -
# need package:
# tar(OS必需), gzip(OS必需, 包含: gunzip, uncompress)
# bzip2(包含: bunzip2), unrar, unzip, p7zip(包含: 7zr)
# 2018年 07月 22日 星期日 15:51:19 CST

extract() {
if [[ -f "$1" ]]; then
  case "$1" in
    *.tar.bz2)
      tar xjf "$1"    
      ;;
    *.tar.gz)
      tar xzf "$1"    
      ;;
    *.bz2)
      bunzip2 "$1"    
      ;;
    *.rar)
      unrar e "$1"    
      ;;
    *.gz)
      gunzip "$1"     
      ;;
    *.tar)
      tar xf "$1"     
      ;;
    *.tbz2)
      tar xjf "$1"    
      ;;
    *.tgz)
      tar xzf "$1"    
      ;;
    *.zip)
      unzip "$1"      
      ;;
    *.Z)
      uncompress "$1" 
      ;;
    *.7z)
      7zr x "$1"       
      ;;
    *)
      echo "$1 cannot be extracted via extract()"
      ;;
  esac
else
  echo "$1 is not a valid file."
fi
}

extract "$1"

