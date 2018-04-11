#!/bin/bash

A=$1
B=$2
d=*
count=`echo $A|wc -m`

for cursor in `seq 1 $count`
do
    c1=`echo $A|cut -c$cursor`
    c2=`echo $B|cut -c$cursor`

    if test "$c1" = "$c2"
    then
        echo -n "$c1"
    else
        echo -n "$d"
    fi
done

echo
