#!/bin/bash -

trap "echo '中断';exit 1" INT
#LANG=C 
sudo apt-get update -y
sudo apt-get dist-upgrade -y
