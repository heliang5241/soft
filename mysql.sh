#!/bin/bash

if [[ $(id -u) -ne 0 ]];then
    echo "You must use this script in root"
    exit 
fi
    echo "Please Set  Password For Mysql root"
#mysqlrootPWD="tianyu"
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
   echo "Has Been Set"
cat >>/etc/security/limits.conf <<EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
   echo "Limits Is Set !! "
fi
cat /etc/sysctl.conf|grep fs.file-max=65535 >/dev/null
if [[ `echo $?` -ne 0 ]];then
   echo "fs.file-max=65535" >> /etc/sysctl.conf
fi
}

function installmysql()
{
if [ -s /etc/my.cnf ];then
   mv /etc/my.cnf /etc/my.cnf_`date +%Y%m%d%H%M%S`.bak
fi
groupadd mysql -g 512
useradd -u 512 -g mysql -s /sbin/nologin -d /home/mysql mysql
tar xvf /root/mysql-5.6.25-linux-glibc2.5-x86_64.tar.gz
mv mysql-5.6.25-linux-glibc2.5-x86_64 /usr/local/mysql
mkdir -p /data/mysql
mkdir -p /log/mysql
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /log
ip=`ifconfig eth0|grep 'inet addr'|cut -c 21-35|awk -F. '{print$3$4}'`
cat >>/etc/my.cnf<<EOF
[client]
port= 3306
socket= /tmp/mysql.sock
default-character-set=utf8
[mysql]
default-character-set=utf8
[mysqld]
port= 3306
socket= /tmp/mysql.sock
basedir= /usr/local/mysql
datadir= /data/mysql
open_files_limit    = 3072
back_log = 103
max_connections = 800
max_connect_errors = 100000
table_open_cache = 512
external-locking = FALSE
max_allowed_packet = 32M
sort_buffer_size = 2M
join_buffer_size = 2M
thread_cache_size = 51
query_cache_size = 32M
tmp_table_size = 96M
max_heap_table_size = 96M
slow_query_log = 1
slow_query_log_file = /log/mysql/slow.log
log-error = /log/mysql/error.log
long_query_time = 1
server-id = $ip
log-bin = mysql-bin
sync_binlog = 1
binlog_cache_size = 4M
max_binlog_cache_size = 4096M
max_binlog_size = 1024M
expire_logs_days = 60
key_buffer_size = 32M
read_buffer_size = 1M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 64M
character-set-server=utf8
default-storage-engine = InnoDB
binlog_format = row
innodb_buffer_pool_dump_at_shutdown = 1
innodb_buffer_pool_load_at_startup = 1
binlog_rows_query_log_events = 1
explicit_defaults_for_timestamp = 1
#log_slave_updates=1
#gtid_mode=on
#enforce_gtid_consistency=1
#innodb_write_io_threads = 8
#innodb_read_io_threads = 8
#innodb_thread_concurrency = 0
transaction_isolation = REPEATABLE-READ
innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 512M
#innodb_data_home_dir =
innodb_data_file_path = ibdata1:1024M:autoextend
innodb_flush_log_at_trx_commit = 1
innodb_log_buffer_size = 16M
innodb_log_file_size = 512M
innodb_log_files_in_group = 2
innodb_max_dirty_pages_pct = 50
innodb_file_per_table = 1
innodb_locks_unsafe_for_binlog = 0
wait_timeout = 14400
interactive_timeout = 14400
skip-name-resolve
[mysqldump]
quick
max_allowed_packet = 32M
EOF

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/mysql --defaults-file=/etc/my.cnf --user=mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 700 /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 2345 mysqld on
cat >> /etc/ld.so.conf.d/mysql-x86_64.conf<<EOF
/usr/local/mysql/lib
EOF
ldconfig
if [ -d "/proc/vz" ];then
ulimit -s unlimited
fi
/etc/init.d/mysqld start
cat >> /etc/profile <<EOF
export PATH=$PATH:/usr/local/mysql/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/mysql/lib
EOF
source /etc/profile
/usr/local/mysql/bin/mysqladmin -u root password $mysqlrootPWD
cat > /tmp/mysql_sec_script<<EOF
use mysql;
delete from mysql.user where user!='root' or host!='localhost';
grant all privileges on *.* to  'sys_admin'@'%' identified by 'tianyu';
flush privileges;
EOF
/usr/local/mysql/bin/mysql -u root -p$mysqlrootPWD -h localhost < /tmp/mysql_sec_script
/etc/init.d/mysqld restart
echo "============================MySQL 5.6.25 install completed========================="
}
function CheckInstall()
{
echo "===================================== Check install ==================================="
clear
ismysql=""
echo "Checking..."
if [ -s /usr/local/mysql/bin/mysql ] && [ -s /usr/local/mysql/bin/mysqld_safe ] && [ -s /etc/my.cnf ]; then
  echo "MySQL: OK"
  ismysql="ok"
  else
  echo "Error: /usr/local/mysql not found!!!MySQL install failed."
fi
if [ "$ismysql" = "ok" ]; then
echo "Install MySQL 5.6.25 completed! enjoy it."
echo "========================================================================="
else
echo "Sorry,Failed to install MySQL!"
echo "You can tail /root/mysql-install.log from your server."
fi
}

setlimit 2>&1 | tee mysql-install.log
installmysql 2>&1 | tee -a mysql-install.log
CheckInstall 2>&1 | tee -a mysql-install.log
CheckInstall 2>&1 | tee -a mysql-install.log
CheckInstall 2>&1 | tee -a mysql-install.log
