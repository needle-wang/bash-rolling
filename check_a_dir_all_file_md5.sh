#!/bin/bash -
#code it in cygwin
#八月 17 2013

find . -type f -print0 | xargs -0 -n 1 md5sum

