#!/bin/bash
hang=`cat /etc/sysconfig/network-scripts/ifcfg-*|grep GATEWAY -n|awk -F ':' '{print $1}'`
first=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |awk '{if(NR=='$hang')print $0;}'|cut -c 1`
message(){
        echo "Usage $0 start|stop"
       
}

stop_gateway(){
if [ $first = '#' ];then
  echo -e "\033[31mGATEWAY HAS BEEN STOPED.DO NOTHING! \033[0m"
  exit;
fi
while [ $first != '#' ]
do
   sed -i ''$hang's/^/#/' /etc/sysconfig/network-scripts/ifcfg-eth0
   hh=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |awk '{if(NR=='$hang')print $0;}'|cut -c 1`
if [ $hh = '#' ];then
   break;
fi
done
/sbin/service network restart
echo -e "\033[31mGATEWAY IS STOPING \033[0m"
}

start_gateway(){
if [ $first = 'G' ];then
  echo -e "\033[31mGATEWAY HAS BEEN STARTED.DO NOTHING! \033[0m"
  exit;
fi
while [ $first = '#' ]
do
   sed -i ''$hang's/^#//' /etc/sysconfig/network-scripts/ifcfg-eth0
   hh=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |awk '{if(NR=='$hang')print $0;}'|cut -c 1`
if [ $hh = 'G' ];then
   break;
fi
done
/sbin/service network restart
echo -e "\033[31mGATEWAY IS STARTING \033[0m"
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
