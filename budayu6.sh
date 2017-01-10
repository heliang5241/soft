#!/bin/bash
a="print the length of the longest line"
for i in $a
do
num=`echo $i|wc -L`
if [ $num -le 4 ];then
echo $i
fi
done

echo "########"
for i in $a
do
if [ ${#i} -le 4 ];then
  echo $i

fi
done
