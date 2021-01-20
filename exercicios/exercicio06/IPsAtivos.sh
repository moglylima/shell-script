#!/bin/bash

SUBREDE=$1


echo "Iniciando análise da rede ${SUBREDE}/24."
echo "O resultado estará em ${SUBREDE}.txt"

./BuscaIpsOn.sh $SUBREDE &
