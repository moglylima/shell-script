#!/bin/bash
#Atualizando repositórios
apt-get update

#Instalando cliente mysql
apt-get install -y mysql-client

#Adicionando arquivo com credenciais
printf "[client]" > ~/.my.cnf
printf "user=alu" >> ~/.my.cnf
printf "password=123alu456" >> ~/.my.cnf

#Acessando banco
mysql -u "alu" -h "172.31.59.18"<<EOF
USE scripts;
CREATE TABLE Teste (atividade INT);
quit;
EOF
