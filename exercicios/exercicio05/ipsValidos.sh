#!/bin/bash
IPS=$1

while read line;
do
	oldIFS = $IFS
	IFS=$'.'
	for i in $(line)
	do
		if[ ${i} -ge 0 ]
		then
			if [ ${i} -le 255 ]
			then
				echo ${i} > ipvalido.txt
			fi
		fi
	done
	IFS=$oldIFS
		
done < $IPS
