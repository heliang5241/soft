#!/bin/bash  
  
USER=root  
create_user(){  
  
    for i in {01..10}  
    do  
         RPASSWD=$(tr -dc [:alpha:] < /dev/urandom |head -c 8)  
         useradd $USER$i  
         echo $RPASSWD|passwd $USER$i --stdin  
         echo $USER$i----$RPASSWD >> /root/userpasswd.txt  
    done  
}  
  
del_user(){  
  
    for j in {01..10}  
    do  
        userdel $USER$j  
        rm -rf /home/$USER$j  
    done  
}  
  
case $1 in  
    create)  
        create_user  
    ;;  
    del)  
        del_user  
    ;;  
    *)  
        echo "Usage:Please use $0 create or $0 del."  
        echo "####################################"  
        echo "create: create user $USER 01-10 and give it random passwd."  
        echo "del: delete $USER 01-10 and /home/$USER 01-10 directory. "  
    ;;  
    esac  
