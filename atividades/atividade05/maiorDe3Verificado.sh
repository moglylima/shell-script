#!/bin/bash

maior=$1
resp=1

for i
do
	if  [[ ${i} = ?(+|-)+([0-9]) ]]
	then
		if [ ${i} -gt ${maior} ]
		then
                		maior=${i}
		fi
	else
		echo  "Opa!!! ${i} não é número."
		resp=0
		
	fi
done

if [ $resp = 1 ]
then
	echo $maior
fi
