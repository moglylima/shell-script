#!/bin/bash

#Instalação apache
sudo apt install -y apache2
#Backup index padrão
sudo mv /var/www/html/index.html /var/www/html/index.html.bkp

printf;
