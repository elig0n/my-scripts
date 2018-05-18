#!/bin/sh

A=$1
B=$2
d=*
c=0

while [[ $c -le ${#A} ]]
do
    c1=${A:$c:1} 
    c2=${B:$c:1}

    if test "${c1}" = "${c2}"
    then
        echo -n "${c1}"
    else
        echo -n "${d}"
    fi
    (( c++ )) 
done

echo
