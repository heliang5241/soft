#!/bin/bash
read -p "please input a number:" number
for ((i=1;i<=$number;i++))
do

    for((j=1;j<=$number;j++))
    do
    echo -e "■ \c"
    done

echo -e "■ \n"
done
