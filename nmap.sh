#!/bin/bash

#check_nmap(){


    if [ ! -f /usr/bin/nmap ];then
    read -p "nmap Not install,Do you want to install nmap(y/n):" answer
        case $answer in
        y|yes|Y|Yes|ys)  
            yum -y install nmap
        ;;
        *)  echo "Don't install"
            exit;
        ;;
        esac

    fi
#}

message(){
        echo "Usage $0 [ port     from(MIN 1)  to(MAX 255) ]"
        echo "Usage $0 [ Example:22      1           254   ]"
        echo "Usage $0 [ Example:1521    2            5    ]"
        echo "Usage $0 [ Example:3306    10           27   ]"

}

#count_parameter(){
     if [ `echo $#` -ne 3 ];then
        message
        exit;    
        
     fi
#}

#saomiao
#get_ip(){
ip1=`ifconfig eth0|grep 'inet addr'|cut -c 21-34|awk -F '.' '{print$1}'`
ip2=`ifconfig eth0|grep 'inet addr'|cut -c 21-34|awk -F '.' '{print$2}'`
ip3=`ifconfig eth0|grep 'inet addr'|cut -c 21-34|awk -F '.' '{print$3}'`
/usr/bin/nmap -p $1 $ip1.$ip2.$ip3.$2-$3 >1.txt
   if [ -f hang.txt ];then
         rm -rf hang.txt

   fi
#get open port's hang
cat 1.txt|grep open >/dev/null

   if [[ `echo $?` -eq 0 ]];then
         hang=`cat 1.txt|grep open -n|awk -F ':' '{print $1}'`
         echo -e $hang >>hang.txt
   fi


   if [ -f ip.txt ];then
         rm -rf ip.txt
   fi

#get open port's lieshu
lieshu=`cat hang.txt| head -n1 | awk -F ' ' '{print NF}'`
   for((i=1;i<=$lieshu;i++)) 
      do
         zhi=`cat hang.txt|awk '{print $'$i'}'`
         let zhi=zhi-3
         ip=`cat 1.txt |awk '{if(NR=='$zhi')print $0;}'|awk '{print $5}'`
   
   if [[ $ip != "" ]];then
        echo $ip $1 port is up
        echo $ip $1 port is up >>ip.log
   fi

      done
rm -rf *.txt
#}
#check_nmap
#count_parameter
#get_ip $1 $2 $3
