#!/bin/bash
/usr/bin/w >1.txt
cat 1.txt|grep -v ^#|grep -v ^$ |while read line
do

export pst=`echo $line |awk '{print $2}'`
export command=`echo $line |awk '{print $8}'`
 if [ $command = 'top' ];then

  echo $pst
  echo $command
pkill -KILL -t $pst
 fi

done
rm -rf 1.txt
