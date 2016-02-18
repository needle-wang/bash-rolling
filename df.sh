#!/bin/bash -
#df the disk partitions

df $@ 2>/dev/null | head -1;
df $@ 2>/dev/null | grep ^/dev | sort -nk 1.9,2.0
