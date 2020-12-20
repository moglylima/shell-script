#!/bin/bash

#Criando arquivo passwd.new alterando o endereço da pasta de todos os alunos
sed 's/home\/alunos/srv\/students/g' /etc/passwd > /home/alunos/moglesonlima/passwd.new 

