#!/bin/bash

SUBREDE=$1
FILESUBREDE=$SUBREDE

echo "INICIO" >> ${FILESUBREDE}txt

for INCREMENTO in $(seq 0 255)
do
       # ping -c 1 ${SUBREDE}${INCREMENTO} | g
	ping -c 1 ${SUBREDE}${INCREMENTO} > /dev/null
	if [ $? -eq 0 ]
	then
		echo "${SUBREDE}${INCREMENTO}  " >> ${FILESUBREDE}txt
	fi
done

echo "FIM" >> ${FILESUBREDE}txt
