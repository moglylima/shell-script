#!/bin/bash

#TEMPO=$1
DIRETORIO=$2

QTD_DIR=`ls $DIRETORIO | wc -l`
#LISTA_DIR
ls $DIRETORIO > lista_init


while true
do
    QTD_DIR_AUX=`ls $DIRETORIO | wc -l`
    ls $DIRETORIO > lista_aux

    if [ $QTD_DIR -eq  $QTD_DIR_AUX ]
    then
        echo "Não houve mudanças"

    #Verificando adição de arquivos
    elif [ $QTD_DIR -lt  $QTD_DIR_AUX ]
    then
        echo "Houve adição"
        diff lista_init lista_aux | grep "> " | cut -f2 -d ">" > alteracaoes
        cat alteracaoes
    #Verificando remoção de arquivos
    elif [ $QTD_DIR -gt  $QTD_DIR_AUX ]
    then
        echo "Houve remoção"
        diff lista_init lista_aux | grep "< " | cut -f2 -d "<" > alteracaoes
        cat alteracaoes



    echo lista_aux > lista_init
    QTD_DIR=$QTD_DIR_AUX
    fi
    
    sleep 10

done



#diff test test1 | grep "> " | cut -f2 -d ">"