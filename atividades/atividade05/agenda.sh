#!/bin/bash
# Correção: 1,0

opcao=$1
nome_add_remove=$2
email=$3


case $opcao in
	adicionar)
		echo $nome_add_remove":"$email >> usuarios.db
		;;
	listar)
		cat ./usuarios.db
		;;
	remover)
		sed -i "/$nome_add_remove/d" usuarios.db
		;;
	*)
		echo "Opcao invalida(adicionar/listar/remover)"
esac
