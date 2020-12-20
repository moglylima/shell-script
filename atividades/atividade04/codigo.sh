#!/bin/bash

#Alterando python a ser usado
#Alterando python globalmente
sed -i 's/python/python3/g' /home/compartilhado/atividade04.py
#Alterando python apenas na primeira linha do arquivo
sed -i '1s/python/python3/' /home/compartilhado/atividade04.py

#Colocando a palavra nota em caixa alta
sed -i 's/nota/NOTA/g' /home/compartilhado/atividade04.py 

#Importando o módulo time
sed -i '2a import time' /home/compartilhado/atividade04.py

#Adicionando print para data e hora atual
sed '$a print(time.ctime())' /home/compartilhado/atividade04.py
