#!/bin/bash

#Instalação apache
apt install -y apache2

#Backup index padrão
mv /var/www/html/index.html /var/www/html/index.html.bkp

 

#Gerando novo Index, para serem direcionados os relatórios
echo "" > /var/www/html/index.html

chmod 777 /var/www/html/index.html
#Script serviço

cat << EOF > /usr/local/bin/servico.sh
#!/bin/bash 
DATA_NOW=$(date +%H:%M:%S-%D)
DATA_ATIVA=$(uptime -p)
CARGA_MEDIA=$(uptime | sed 's/ * / /g' | cut -d" " -f9,10,11)
MEM_USADA=$(free -h | grep Mem: | sed 's/ * / /g' | cut -d" " -f3)
MEM_LIVRE=$(free -h | grep Mem: | sed 's/ * / /g' | cut -d" " -f4)
BYTES_RECEBIDOS=$(cat /proc/net/dev | grep eth0: | sed 's/ * / /g' | cut -d" " -f3)
BYTES_TRANSMITIDOS=$(cat /proc/net/dev | grep eth0: | sed 's/ * / /g' | cut -d" " -f11)
INSERT=$(echo "<li>Data: $DATA_NOW Ativa: $DATA_ATIVA | Carga Média: $CARGA_MEDIA | Memória Usada: $MEM_USADA | Memória Livre: $MEM_LIVRE | Bytes Recebidos: $BYTES_RECEBIDOS | Bytes Transmitidos: $BYTES_TRANSMITIDOS</li>)

#Guardando dados
printf $INSERT >> /home/ubuntu/relatorio_servico.txt"

#Jogando dados no index.html"
printf "<html>" > /var/www/html/index.html
printf "<head>" >> /var/www/html/index.html
printf "<title>Atividade 16</title>" >> /var/www/html/index.html
printf "</head>" >> /var/www/html/index.html
printf "<body>" >> /var/www/html/index.html
printf "<ol>" >> /var/www/html/index.html

cat /home/ubuntu/relatorio_servico.txt >> /var/www/html/index.html"

printf "</ol>" >> /var/www/html/index.html"
printf "</body>" >> /var/www/html/index.html"
printf "</html>" >> /var/www/html/index.html
EOF

chmod 744 /usr/local/bin/servico.sh

echo "*/1 * * * * root /usr/local/bin/servico.sh" >> /etc/crontab






















    








------------------


chmod 744 /usr/local/bin/servico.sh

#Adicionando serviço
printf "[Unit]\nAfter=network.target\n[Service]\nExecStart=/usr/local/bin/servico.sh\n[Install]\nWantedBy=default.target\n" > /etc/systemd/system/relatorio.service

chmod 664 /etc/systemd/system/relatorio.service

# Em momento algum você habilita ou inicializa o serviço.
# Portanto, acaba mostrando uma página estática.

#Reinicializando apache2
systemctl restart apache2
