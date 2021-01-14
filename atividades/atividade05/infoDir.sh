#!/bin/bash

PARAMETRO=$1

if [ -d ${PARAMETRO} ]
then
	QTDITENS=`ls ${PARAMETRO} | wc -l`
	DIRSIZE=`du -sk ${PARAMETRO} | cut -f1`

	echo "O diretório ${PARAMETRO} ocupa ${DIRSIZE} kilobytes e tem ${QTDITENS} itens."
else
	echo "${PARAMETRO} não é um diretório!!!"
fi

