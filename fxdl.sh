#!/bin/bash
ps -ef|grep ssh|grep 15024 >/dev/null
if [ `echo $?` -eq 0 ];
 then 
     echo "`date "+%y%m%d %H%M%S"---`ssh is already runing!" >>/root/shell/check_fxdl.log 
else
     echo  "`date "+%y%m%d %H%M%S"---`begin to start $0" >>/root/shell/check_fxdl.log
     /root/shell/ssh_init.exp 
fi


