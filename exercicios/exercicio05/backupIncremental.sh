#!/bin/bash

DIR_01=$1
#DIR_02=$2

ITENS=`ls -l ${DIR_01}`
QTDITENS=`ls -l ${DIR_01} | grep "^-" -c`

echo "$ITENS"
echo "$QTDITENS"

#for x in $(seq 1 $QTDITENS)
#do
		

#done
