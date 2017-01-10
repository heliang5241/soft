#!/bin/bash
work_dir=/ee/

change_name()

{

FILE=`ls $work_dir`
DIR=_oldgir.HTML
for i in $FILE

do
#c=`echo $i|cut -c 1-10`
c=`echo $i|awk -F '_' '{print$1}'`
mv $work_dir$c* $work_dir$c$DIR

done
}

change_name
