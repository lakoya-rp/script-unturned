#!/bin/bash

$1='nameserver'
cd $folder
ulimit -n 2048
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`dirname $0`/Unturned_Headless_Data/Plugins/x86_64/

./Unturned_Headless.x86_64 -logfile 2>&1 -batchmode -nographics  +secureserver/$nameserver