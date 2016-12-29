#!/bin/bash
date=`date +%F\-%T`
work_dir=/home/remote/apache-tomcat-new
echo ">>>>>Kill Java Begin>>>>>"
ps -ef |grep java |grep -v grep >/dev/null 
while [[ `echo $?` -eq 0 ]]
do
ps -ef |grep java |grep -v grep |awk '{print $2}' |xargs kill -9
done
echo ">>>>>Clean Cache Begin>>>>>"
rm -rf $work_dir/temp/*
rm -rf $work_dir/work/*
rm -rf $work_dir/conf/Catalina/*
echo "<<<<<Clean Cache End<<<<<"
cd $work_dir
if [ ! -f bakup ];then
     mkdir -p bakup

fi
echo ">>>>>Bakup Webapps Begin>>>>>"
tar zcvf bakup/$date.tar.gz webapps/
echo "<<<<<Bakup Webapps End<<<<<"
rm -rf webapps/*


 

