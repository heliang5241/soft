#!/bin/bash
echo $0
if [[ `echo $0|cut -c 1` = . ]];then
  echo "Fail,run the script like sh `echo $0|cut -c 3-10` not ./`echo $0|cut -c 3-10`"
  exit;

fi
if [ -f 2.txt ];then
rm -rf 2.txt
fi
/usr/bin/w >1.txt
cat 1.txt|grep -v ^#|grep -v ^$ |while read line
do

export pst=`echo $line |awk '{print $2}'`
export command=`echo $line |awk '{print $9}'`
echo $pst $command >>2.txt
echo $command |grep `echo $0|awk -F '.' '{print $1}'` >/dev/null

if [[ `echo $?` -eq 0 ]];then
  echo "pass"

else
  echo "kill"
  pkill -KILL -t $pst

fi
done

rm -rf 1.txt
rm -rf 2.txt
