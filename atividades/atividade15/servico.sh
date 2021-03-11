#!/bin/bash
while true
do

    DATA_NOW=$(date +%H:%M:%S-%D)
    DATA_ATIVA=$(uptime -p)

    CARGA_MEDIA=$(uptime | sed 's/ * / /g' | cut -d" " -f9,10,11)

    MEM_USADA=$(free -h | grep Mem: | sed 's/ * / /g' | cut -d" " -f3)

    MEM_LIVRE=$(free -h | grep Mem: | sed 's/ * / /g' | cut -d" " -f4)
    BYTES_RECEBIDOS=$(cat /proc/net/dev | grep eth0: | sed 's/ * / /g' | cut -d" " -f3)

    BYTES_TRANSMITIDOS=$(cat /proc/net/dev | grep eth0: | sed 's/ * / /g' | cut -d" " -f11)

    INSERT=$(echo "Data: $DATA_NOW Ativa: $DATA_ATIVA | Carga Média: $CARGA_MEDIA | Memória Usada: $MEM_USADA | Memória Livre: $MEM_LIVRE | Bytes Recebidos: $BYTES_RECEBIDOS | Bytes Transmitidos: $BYTES_TRANSMITIDOS)
    #Guardando dados 
    echo $INSERT >> /tmp/relatorio_serviço.txt

    sleep 5
done

