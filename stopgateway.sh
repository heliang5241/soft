#!/bin/bash
#first=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |awk '{if(NR==11)print $0;}'|cut -c 1`
hang=`cat /etc/sysconfig/network-scripts/ifcfg-*|grep GATEWAY -n|awk -F ':' '{print $1}'`
message(){
        echo "Usage $0 start|stop"
       
}

stop_gateway(){
sed -i ''$hang's/^/#/' /etc/sysconfig/network-scripts/ifcfg-eth0
}

start_gateway(){
first=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |awk '{if(NR==11)print $0;}'|cut -c 1`
while [ $first = '#' ]
do
   sed -i ''$hang's/^#//' /etc/sysconfig/network-scripts/ifcfg-eth0
if [ $first != '#' ];then
   break;
fi
done
}

case $1 in
stop)
    stop_gateway
	;;
start)
    start_gateway
	;;
*)  
    message
    exit;
    ;;
esac
