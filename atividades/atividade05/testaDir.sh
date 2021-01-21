#!/bin/bash
# Correção: 1,0

PARAMETRO=$1
DIRSIZE= `du -sk ${PARAMETRO} | cut -f1` 
QTDITENS= `ls -l ${PARAMETRO} | grep "^-" -c`
if [ -d ${dir} ]
then 
	echo "O diretório ${PARAMETRO} ocupa ${DIRSIZE} kilobytes e tem ${QTDITENS} itens."
else
	echo "${PARAMETRO} não é um diretório!!!"
fi

