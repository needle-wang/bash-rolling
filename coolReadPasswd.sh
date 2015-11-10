#!/bin/bash -
#

#cool!

#set -x
while IFS=: read user pass uid gid fullname homedir shell
do
echo $user $pass $uid $gid $fullname $homedir $shell
done</etc/passwd

#set +x
