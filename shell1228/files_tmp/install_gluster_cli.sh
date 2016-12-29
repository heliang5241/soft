#!/bin/bash

#update by csc 20161208

mount_gv_cloud(){
 mkdir -p /gfs_mnt/data1
/bin/mount -t glusterfs ${1}:/gv_cloud  /gfs_mnt/data1
cat >>/etc/rc.local <<EOF
/bin/mount -t glusterfs ${1}:/gv_cloud  /gfs_mnt/data1
EOF

}

mount_gv_space_uploads(){

mkdir -p /space_uploads
mkdir -p  /data0/htdocs/www/eduyun/space/
/bin/mount -t glusterfs ${1}:/gv_uploads  /space_uploads
ln -s /space_uploads   /data0/htdocs/www/eduyun/space/uploads

cat >>/etc/rc.local <<EOF  
/bin/mount -t glusterfs ${1}:/gv_uploads  /space_uploads
EOF

}


mount_gv_aam_uploads(){
mkdir -p /aam_uploads
mkdir -p  /home/aamif
/bin/mount -t glusterfs ${1}:/gv_uploads  /aam_uploads
ln -s /aam_uploads  /home/aamif/execelresource
  
cat >>/etc/rc.local <<EOF  
/bin/mount -t glusterfs ${1}:/gv_uploads  /aam_uploads
EOF

}

install_glusterfs_3(){

rpm -qa|grep "glusterfs-3." >/dev/null
if [ $? -ne 0 ];then
 rpm  -Uvh  glusterfs-client/*.rpm

 modprobe fuse
 lsmod | grep fuse
 echo  "modprobe fuse" >>/etc/rc.local
  
 echo 'umask 0000' >>/etc/profile
 source  /etc/profile
else
echo  -e "\n  glusterfs3.0 had install ! \n"
fi

}


#######################
gfs_server_ip1="192.168.96.38"
gfs_server_ip2="192.168.96.39"

install_glusterfs_3

#mount_gv_cloud  "${gfs_server_ip1}"
#mount_gv_space_uploads "${gfs_server_ip2}"
#mount_gv_aam_uploads "${gfs_server_ip2}"

df -h 



