#!/bin/bash
user=aa
create_user()
{
for i in {01..10}
do
PASSWD=`tr -dc [:alpha:] </dev/urandom |head -c 10`
useradd $user$i
echo $PASSWD|passwd --stdin $user$i
echo $user$i----$PASSWD >>/root/passwd.txt

done
}
del_user()
{
for i in {01..10}
do
userdel -r $user$i
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
    echo "create: create user $user 01-10 and give it random passwd."  
    echo "del: delete $user 01-10 and /home/$user 01-10 directory. "  
    ;;
esac


