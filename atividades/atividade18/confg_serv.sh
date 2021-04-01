#!/bin/bash
#Atualizando repositórios
apt-get update
#Instalando servidor mysql
apt-get install -y mysql-server
#Configurando para receber conexões
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
#Reiniciando mysql.service
systemctl restart mysql.service 

#Criando Banco scripts
mysql<<EOF2
CREATE DATABASE scripts;
CREATE USER 'alu'@'%' IDENTIFIED BY '123alu456';
GRANT ALL PRIVILEGES ON scripts.* TO 'alu'@'%';
quit;
EOF2

