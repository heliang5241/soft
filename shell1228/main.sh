#!/bin/bash
version="update  shell  V1.2 by csc 2016-12-28"
echo  "$version"

#------------------------------------------------------


ssh_init_while(){
REMOTE_IP="$1"
REMOTE_PASS="$2"
./script_exp/ssh_init.exp $REMOTE_IP $REMOTE_PASS >/dev/null 2>&1
SSH_RET=$?

if [ "${SSH_RET}" = "0" ]; then
        echo "Had DONE NO password authorized from local to $REMOTE_IP, This server ssh mybe down ! ."
        echo "$REMOTE_IP " >> ssh_fail.log
        continue
fi

}


exp_file(){


if [ -z "$1" ];then
message
exit 1
fi


if [ ! -f "$1" ];then
echo "warning --- file $1 is not exist ! "
exit 1
fi


cat $1 |grep -v ^#|grep -v ^$ |while read line

do

echo $line |grep REMOTE_PASS  >/dev/null

if [ $? -eq 0 ];then
export $line
#echo $line
continue
fi


export REMOTE_IP=`echo $line |awk '{print$1}'`

if [ -n "`echo $line|awk '{print$2}'`" ];then
export  REMOTE_PASS_Appoint=`echo $line|awk '{print$2}'`

ssh_init_while "$REMOTE_IP"  "$REMOTE_PASS_Appoint"
./script_exp/tranfile.exp  "$REMOTE_IP" "$REMOTE_PASS_Appoint" >/dev/null 2>&1
./script_exp/runcmd.exp  "$REMOTE_IP" "$REMOTE_PASS_Appoint"

else

cat ./files_exp/runcmd.sh |grep -E "rm|reboot|shutdown|hart" > /dev/null

if [ $? -eq 0 ];then
echo "WARNING -- There are dangerous commands in the script runcmd.sh ! please check !"
exit 1
fi

ssh_init_while "$REMOTE_IP"  "$REMOTE_PASS"
./script_exp/tranfile.exp  "$REMOTE_IP" "$REMOTE_PASS" >/dev/null 2>&1
./script_exp/runcmd.exp  "$REMOTE_IP" "$REMOTE_PASS"

fi
sleep 2

done

}

exp_command(){


REMOTE_IP="$1"
REMOTE_PASS="$2"
RUNCOMMAND="$3"

if [ -z "$REMOTE_PASS" ];then
ipasswd=`cat ./*.conf |grep "REMOTE_PASS"|head -1` >/dev/null
if [ -n "$ipasswd" ];then
export ${ipasswd}
echo "Ok -- use password in `ls *.conf` , $ipasswd !"
else
echo "warning -- not find password or not find password in `ls *.conf` !"
fi



fi

echo  $RUNCOMMAND |grep -E "rm|reboot|shutdown|hart" > /dev/null

if [ $? -eq 0 ];then
echo "WARNING -- There are dangerous commands in the cmd $RUNCOMMAND , please check !"
exit 1
fi


./script_exp/ssh_init.exp $REMOTE_IP $REMOTE_PASS >/dev/null 2>&1
SSH_RET=$?

if [ "${SSH_RET}" = "0" ]; then
        echo "Had DONE NO password authorized from local to $REMOTE_IP, This server ssh mybe down ! ."
        echo "$REMOTE_IP " >> ip_ssh_fail.log
	exit 1
fi

if [ -z "$RUNCOMMAND" ];then

./script_exp/tranfile.exp "$REMOTE_IP" "$REMOTE_PASS" >/dev/null 2>&1
./script_exp/runcmd.exp   "$REMOTE_IP" "$REMOTE_PASS"

else
./script_exp/runcommand.exp  "$REMOTE_IP" "$REMOTE_PASS" "$RUNCOMMAND"
fi


}

message(){
echo "warning -- usage $0 -f ip_pass.conf" 
echo "        -- usage $0 -h 192.168.1.1  | (passwd is Define in ip_pass.conf,command is define in runcmd.sh)"
echo "        -- usage $0 -h 192.168.1.1 -p password | (command is define in runcmd.sh)"
echo "        -- usage $0 -h 192.168.1.1 -c 'free -m' | (passwd is Define in ip_pass.conf)"
echo "        -- usage $0 -h 192.168.1.1 -p password  -c 'free -m' "
}


################################


if [ ! -f /usr/bin/expect ]; then
echo "error: NO expect! please install expect "
echo "EXP: yum install expect "
exit
fi

if [ ! -e ./files_exp/runcmd.sh ];then
echo "warnning -- ./files_exp/runcmd.sh is not exist !"
exit 1
fi

if [ $# -eq 0 ];then
message
exit 0
fi

until [ $# -eq 0 ];do

case "$1" in
        -f)
        exp_file "$2"
        exit 0
        ;;

        -h)
        exp_hostip="$2"
        shift
        ;;

        -c)
        exp_command="$2"
        shift
	;;

        -p)
        exp_password="$2"
        shift
        ;;
        
        --help)
        message
        exit 0
        ;;        

        *)
        echo "unkown options $1"
        exit 1
        #break
        ;;

esac

shift
done


if [ -z "$exp_hostip" ];then
message
exit 1
fi

#if [ -z "$exp_password" ] && [ -n "$exp_hostip" ] && [ -n "$exp_command" ];then
#exp_command "$exp_hostip" "$root_passwd" "$exp_command"
#fi

if [ -n "$exp_password" ] || [ -n "$exp_hostip" ];then
exp_command "$exp_hostip" "$exp_password" "$exp_command"
fi



