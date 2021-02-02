#!/bin/bash

echo "Informe o arquivo: "
read ARQUIVO

#Realizando contagem, armazenando dentro de um arquivo tmp

#cat $ARQUIVO | egrep -o "\w+" | sort | uniq -c | sed 's/      //g' | sed 's/     //g' > tmp 
#cat $ARQUIVO | egrep -o "\w+" | sort | uniq -c | sed -e 's/^[[:blank:]]*//' > tmp

cat $ARQUIVO | egrep -o "\w+" | sort | uniq -c | sed -e 's/^[[:space:]]*//' > tmp

#Mostrando resultados
while read LINHA
do
	PALAVRA=`echo $LINHA | cut -d" " -f2`
	QTD=`echo $LINHA | cut -d" " -f1`
	printf "%s : %s\n" $PALAVRA $QTD
done < tmp

#Removendo arquivo tmp
rm tmp