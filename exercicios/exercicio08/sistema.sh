#!/bin/bash

#Pegando o sinal CTRL+C
trap "clear; exit" 2

OPCAO=""

menu(){
clear
echo "MENU:"
echo "1 - tempo ligado"
echo "2 - Ultimas mensagens kernel"
echo "3 - Memória Virtual"
echo "4 - CPU por Nucleo"
echo "5 - CPU por processo"
echo "6 - Memória Fisica"

read -p "Informe uma opção -> " OPCAO
}


tempo_ligado(){
	uptime
	read enter
	clear
}

mensagens_kernel(){
	dmesg | tail -n 10
	read enter
	clear
}

memoria_virtual(){
	vmstat 1 10
	read enter
	clear
}

cpu_nucleo(){
	mpstat -P ALL 1 5
	read enter
	clear
}

cpu_processo(){
	pidstat 1 5
	read enter
	clear
}

uso_memoria(){
	free -m
	read enter
	clear
}


while [ true ]
do
	menu
	clear
	case $OPCAO in
		1)
		tempo_ligado
		;;
		2)
		mensagens_kernel
		;;
		3)
		memoria_virtual
		;;
		4)
		cpu_nucleo
		;;
		5)
		cpu_processo
		;;
		6)
		uso_memoria
		;;
		*)
		read enter	
	esac
done
