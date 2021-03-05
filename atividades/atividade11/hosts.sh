#!/bin/bash
# OK
ACAO=""
HOSTNAME=""
IP=""
BUSCA=$1

#Capturando opções
while getopts "a:i:ld:r:" OPTVAR
do 
    case "${OPTVAR}" in
        a)ACAO="adicionar"
        HOSTNAME=$OPTARG
        ;;
        i)IP=$OPTARG
        ;;
        l)ACAO="listar"
        ;;
        d)ACAO="deletar"
        HOSTNAME=$OPTARG
        ;;
        r)ACAO="buscar"
        HOSTNAME=$OPTARG
        ;;
        *)
    esac
done


#Operações/funções
adicionar(){
    echo $HOSTNAME" "$IP>>hosts.db
}

listar(){
    cat hosts.db

}

deletar(){
    sed -i "/$HOSTNAME/d" hosts.db
    echo "$HOSTNAME deletado!!!"

}

busca_host_ip(){
    
    RESP=`grep "$HOSTNAME" hosts.db  2> /dev/null`

    if [ $? -eq "0" ]
    then
        echo "$RESP" |  cut -d " " -f1

    else
        echo "Host não encontrado!"
    fi
}

busca_host_name(){
    RESP=`grep "$BUSCA" hosts.db  2> /dev/null`

    if [ $? -eq "0" ]
    then
        echo "$RESP" | cut -d " " -f2

    else
        echo "Host não encontrado!"
    fi

}

#Verificando parametros e realizando operações(Chamada de funções)
case $ACAO in
    adicionar)
        adicionar
        ;;
    listar)
        listar
        ;;
    deletar)
        deletar $HOSTNAME
        ;;
    buscar)
        busca_host_ip
        ;;
        *)
        busca_host_name 
esac




