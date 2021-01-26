#!/bin/bash

declare -a VETOR
i=0

read -p "Informe um numero (q para sair):" ENTRADA

until [ "$ENTRADA" == "q" ]
do
	VETOR[$i]=$ENTRADA
	i=$(($i + 1))
	read -p "Informa um numero (q para sair):" ENTRADA
done

printf "Foram inseridos %i numeros\n" "$i"
