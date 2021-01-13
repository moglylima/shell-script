#!/bin/bash

parametro=$1


if [ -r ${parametro} ]
then
	itens= ls ${parametro} | wc -l
	tamanho= du -sk ${parametro} | cut -f1

	echo ""
else
	echo "${parametro} não é um diretório!!!"
fi

