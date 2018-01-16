#!/bin/bash
#testjobadmin.yinpiao.com
nginx_path=/root/vhost
find $nginx_path -name *.conf>/tmp/conf_path.txt
for i in `cat /tmp/conf_path.txt|awk '{print $1}'`; do
	cat $i |grep -i $1 >/dev/null 2>&1
	if [ $? = 0 ]; then
		echo $i
	fi
done			




