#!/bin/bash

dir1=$(echo $1 | sed 's/\/$//')
dir2=$(echo $2 | sed 's/\/$//')

for i in $(find $dir1/*)
do
        dire=$(date -r $i +$dir2/%Y/%m/%d/)
        mkdir -p $dire
        cp $i $dire
done
