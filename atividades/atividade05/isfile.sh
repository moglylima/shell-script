#!/bin/bash
# Correção: 1,0

parametro=$1

if [ -f "$parametro" ]
then
	echo "E um arquivo"

elif [ -d "$parametro" ]
then 
	echo "E um diretorio"
fi

if [ -r "$parametro" ]
then 
	echo "Tem permissao de leitura"
else 
	echo "Nao tem permisao de leitura"

fi


if [ -w "$parametro" ]
then
        echo "Tem permissao de escrita"
else
        echo "Nao tem permisao de escrita"

fi
