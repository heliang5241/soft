#!/bin/bash

if [[ $(id -u) -ne 0 ]];then
    
    echo "You must use this script in root"
    exit 
fi

    echo "Please Set  Password For Mysql root"
    read -p "Please Input Password(Default tianyu):" mysqlrootPWD

if [[ $mysqlrootPWD = "" ]];then
   
    mysqlrootPWD="tianyu"

fi
    echo "Set Password $mysqlrootPWD For Mysql root"

    read -p "Do You Want Install Mysql(yes/no Default no):" isinstallmysql

if [[ $isinstallmysql = "" ]];then
     isinstallmysql="no"
fi
case "$isinstallmysql" in
yes|YES|y|Yes|Y|YeS|YEs|yES|yEs|yeS)

    echo "Yes,I want install"

    ;;

*)
    echo "No,I don't want install"
    exit
    ;;

esac

MEM=`free -m|grep Mem|awk '{print $2}'`
echo "System Memory is $MEM"
if [ -s /etc/sysconfig/selinux ];then
 
   sed -i "s@SELINUX=enforcing@SELINUX=disabled@" /etc/sysconfig/selinux 
fi
setenforce 0
function setlimit()
{
cat /etc/security/limits.conf|grep "* soft nproc 65535" >/dev/null
if [[ `echo $?` -ne 0 ]];then
 
   echo "bak"
cat >>/etc/security/limits.conf <<EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF

else
   echo "Limits Is Set !! "
fi

cat /etc/sysctl.conf|grep fs.file-max=65535 >/dev/null
if [[ `echo $?` -ne 0 ]];then
   echo "fs.file-max=65535" >> /etc/sysctl.conf

fi
}

if [ -s /etc/my.cnf ];then
  
   mv /etc/my.cnf /etc/my.cnf_`date +%Y%m%d%H%M%S`.bak
fi
groupadd mysql -g 512
useradd -u 512 -g mysql -s /sbin/nologin -d /home/mysql mysql
tar xvf /root/mysql-5.6.25-linux-glibc2.5-x86_64.tar.gz
mv /root/mysql-5.6.25-linux-glibc2.5-x86_64 /usr/local/mysql
mkdir -p /data/mysql
mkdir -p /log/mysql
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /log





setlimit
