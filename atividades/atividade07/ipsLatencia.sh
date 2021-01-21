#!/bin/bash
# Correção: 0,5

arquivo=$1

echo "Aguarde um momento..."
while read linha
do	
	latencia=$(ping -c 5 $linha|grep "rtt" | cut -f5 -d"/" 2>/dev/null)
	echo "$linha  ${latencia}ms" >> ips_temp.txt

done <$arquivo

echo "Relatório de latencia"
sort -n ips_temp.txt | cat
rm ips_temp.txt
