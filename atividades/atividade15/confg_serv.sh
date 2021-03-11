#!/bin/bash

#Instalação apache
apt install -y apache2

#Backup index padrão
mv /var/www/html/index.html /var/www/html/index.html.bkp

#Gerando novo Index, para serem direcionados os relatórios
printf "<html lang="pt-br">\n  <head>\n    <title>Atividade 15 Programação de scripts</title>\n    <meta charset="utf-8">\n  </head>\n  <body>\n    <h2>Realatório Servidor</h2>\n   <ol>\n Fim... \n</ol>    \n</body>\n</html>\n" > /var/www/html/index.html

#Reinicializando apache2
systemctl restart apache2
