#!/bin/bash
work_dir=/ee

create()
{
i=1
while(($i<11))
do
cd $work_dir && touch `tr -dc "a-z" </dev/urandom|head -c 10`_oldboy.html
i=$(($i+1))
done
}
check()
{
if [ ! -d $work_dir ];then
mkdir $work_dir
create
else
create
fi

}
check
