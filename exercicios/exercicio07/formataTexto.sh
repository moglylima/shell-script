#!/bin/bash
# Correção: 0,5

FORMATO=$1
COR=$2
POSICAO=$3
MSG=$4

case $FORMATO in
	sublinhado)
		OPCAO="smul"	
		;;
	negrito)
		OPCAO="bold"
		;;
	reverso)
		OPCAO="smso"
		;;
	*)
esac



tput ${OPCAO}
tput setaf ${COR}
tput cup $(echo $POSICAO | tr -s ',' ' ')
echo ${MSG}

