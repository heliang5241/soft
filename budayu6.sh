#!/bin/bash
a="print the length of the longest line"
for i in $a
do
num=`echo $i|wc -L`
if [ $num -le 2 ];then
echo $i
fi
done
