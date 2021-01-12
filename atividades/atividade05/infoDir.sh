#!/bin/bash

parametro=$1
itens=0

if [ -r ${parametro} ]
then
	echo "OK!!!"
	itens= ls ${paramentro} | wc -l
	echo ${itens}
else
	echo "${parametro} não é um diretório!!!"
fi
