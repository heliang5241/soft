#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f /usr/bin/expect ]; then
echo "error: NO expect!"
exit
fi
date=`date +%F\ %T`
DATE=`date +'%Y-%m-%d'`
LOG=$DATE.log

    echo "============================================"

    echo -e "\033[33m You have 3 options for your WebApps Update. \033[0m"
    echo "1: Update WebApps 192.168.150.34 only" 
    echo "2: Update WebApps 192.168.150.14 only" 
    echo "3: Update WebApps ALL" 
    #echo "4: "
    #echo "5: "
    read -p "Enter your choice (1, 2 or 3): " Select

    case "${Select}" in
    1)
        echo "You will update WebApps 192.168.150.34 only" 
        ;;
    2)
        echo "You will update WebApps 192.168.150.14 only" 
        ;;
    3)
        echo "You will update WebApps ALL" 
        ;;
    #4)
    #    echo ""
    #   ;;
    #5)
    #   echo ""
    #  ;;
    *)
        echo -e "\033[31m Done nothing,Exit. \033[0m"
        exit;

    esac

rm -rf ping_failIP
rm -rf passwd_failIP
cat ip/ip$Select.txt|grep -v ^#|grep -v ^$ |while read line

do
export WORK_DIR=/home/remote/apache-tomcat-new
export REMOTE_IP=`echo $line |awk '{print$1}'`
export REMOTE_PASS=`echo $line |awk '{print$2}'`
if [ "$REMOTE_PASS" = "" ];then
       
      export REMOTE_PASS=Whty#1234

fi
sleep 1
ping -c 3 $REMOTE_IP >/dev/null
if [[ `echo $?` -ne 0 ]]; then
       echo "$REMOTE_IP MAYBE DOWN!" 
       echo $REMOTE_IP >> ping_failIP  
       continue
fi
./script/ssh_init.exp $REMOTE_IP $REMOTE_PASS
SSH_RET=$?
echo $SSH_RET
if [ "${SSH_RET}" = "0" ]; then
       echo $REMOTE_IP >>passwd_failIP
       echo "Had DONE NO password authorized from local to $REMOTE_IP, Don't worry."
       continue
fi
./script/transhell.exp   $REMOTE_IP $REMOTE_PASS 2>&1 |tee log1.txt 
./script/stoptomcat.exp  $REMOTE_IP $REMOTE_PASS 2>&1 |tee log2.txt 
./script/tranwebapp.exp  $REMOTE_IP $REMOTE_PASS $WORK_DIR 2>&1 |tee log3.txt
./script/starttomcat.exp $REMOTE_IP $REMOTE_PASS $WORK_DIR 2>&1 |tee log4.txt

       rm -rf *.log
       echo "Update At Time $date " >$LOG
       cat log1.txt >> $LOG
       cat log2.txt >> $LOG
       cat log3.txt >> $LOG
       cat log4.txt >> $LOG
       rm -rf *.txt
echo '---------Update Success---------'

done
