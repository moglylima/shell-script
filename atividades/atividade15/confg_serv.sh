#!/bin/bash

#Instalação apache
apt install -y apache2

#Backup index padrão
mv /var/www/html/index.html /var/www/html/index.html.bkp

#Gerando novo Index, para serem direcionados os relatórios
printf "<html lang="pt-br">\n  <head>\n    <title>Atividade 15 Programação de scripts</title>\n    <meta charset="utf-8">\n  </head>\n  <body>\n    <h2>Realatório Servidor</h2>\n   <ol>\n Fim... \n</ol>    \n</body>\n</html>\n" > /var/www/html/index.html

#Script serviço
printf "" > /usr/local/bin/servico.sh

chmod 744 /usr/local/bin/servico.sh

#Adicionando serviço
printf "[Unit]\nAfter=network.target\n[Service]\nExecStart=/usr/local/bin/servico.sh\n[Install]\nWantedBy=default.target\n" > /etc/systemd/system/relatorio.service

chmod 664 /etc/systemd/system/relatorio.service


#Reinicializando apache2
systemctl restart apache2
