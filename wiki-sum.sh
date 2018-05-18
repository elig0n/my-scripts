#!/bin/sh

TMPFILE=/tmp/wiki-sum.html
 
SEARCH="$@"

curl -L -s "https://en.wikipedia.org/wiki/${SEARCH}" | grep \/table -A400 | grep -v \/table  | grep "\<div" -m1 -B400 | sed -e "\$d" > $TMPFILE
 
w3m -dump $TMPFILE
 
rm $TMPFILE

