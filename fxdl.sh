[root@agent ~]# cat check_fxdl.sh 
#!/bin/bash
ps -ef|grep ssh|grep 17788 >/dev/null
if [ `echo $?` -eq 0 ];
 then 
     echo "ok" 
else
     ./ssh_init.exp 
fi
[root@agent ~]# cat ssh_init.exp 
#!/usr/bin/expect -f

set timeout 600
match_max 20000
send_user ">>>>> check_fxdl   >>>>>\r\n"

spawn ssh -p 2022 -R 116.211.105.51:17788:172.17.60.58:22 remote@116.211.105.51
expect "password: "
send "5IkkdBHg6C_wPkXIt-Vs\r"

expect "]*"
send "vmstat 30  \r"

expect eof { send_user "<<<<< check_fxdl   <<<<<\n\n" }



[root@agent ~]# cat check_fxdl.sh 
#!/bin/bash
ps -ef|grep ssh|grep 19999 >/dev/null
if [ `echo $?` -eq 0 ];
 then 
     echo "ok" 
else
     ./ssh_init.exp 
fi
[root@agent ~]# cat ssh_init.exp 
#!/usr/bin/expect -f

set timeout 600
match_max 20000
send_user ">>>>> check_fxdl   >>>>>\r\n"

spawn ssh -p 21022 -R 61.183.234.147:19999:172.17.60.58:22 jiaoyu@61.183.234.147
expect "password: "
send "Linux123!@#\r"
expect "(yes/no)?"
send "yes\r"
expect "]*"
send "vmstat 30  \r"

expect eof { send_user "<<<<< check_fxdl   <<<<<\n\n" }










[root@agent ~]# cat check_fxdl.sh 
#!/bin/bash
ps -ef|grep ssh|grep 17777 >/dev/null
if [ `echo $?` -eq 0 ];
 then 
     echo "ok" 
else
     ./ssh_init.exp 
fi
[root@agent ~]# cat ssh_init.exp 
#!/usr/bin/expect -f

set timeout 600
match_max 20000
send_user ">>>>> check_fxdl   >>>>>\r\n"

spawn ssh -p 21022 -R 61.183.234.147:17777:172.17.60.58:22 jiaoyu@61.183.234.147
expect "password: "
send "Linux123!@#\r"

expect "]*"
send "vmstat 30  \r"

expect eof { send_user "<<<<< check_fxdl   <<<<<\n\n" }



#!/bin/bash
netstat -tnlp|grep 2007 >/dev/null
if [ `echo $?` -eq 0 ];
 then 
     echo "ok" 
else
     /root/filetrans/fileserver.sh
fi



