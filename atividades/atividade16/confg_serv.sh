#!/bin/bash

#Instalação apache
apt install -y apache2

#Backup index padrão
mv /var/www/html/index.html /var/www/html/index.html.bkp

#Gerando novo Index, para serem direcionados os relatórios
touch > /var/www/html/index.html

chmod +rw /var/www/html/index.html

#Script serviço
touch /usr/local/bin/servico.sh

cat << EOF > /usr/local/bin/servico.sh
#!/bin/bash
#Coletando dados
DATA_NOW=\$(date +%H:%M:%S-%D)
DATA_ATIVA=\$(uptime -p)
CARGA_MEDIA=\$(uptime | sed 's/ * / /g' | cut -d" " -f10,11,12)
MEM_USADA=\$(free -h | grep Mem: | sed 's/ * / /g' | cut -d" " -f3)
MEM_LIVRE=\$(free -h | grep Mem: | sed 's/ * / /g' | cut -d" " -f4)
BYTES_RECEBIDOS=\$(cat /proc/net/dev | grep eth0: | sed 's/ * / /g' | cut -d" " -f3)
BYTES_TRANSMITIDOS=\$(cat /proc/net/dev | grep eth0: | sed 's/ * / /g' | cut -d" " -f11)

#Guardando dados em /home/ubuntu/relatorio_servico.log
echo "<li>Data: \$DATA_NOW Tempo ativa: \$DATA_ATIVA | Carga Media: \$CARGA_MEDIA | Memoria Usada: \$MEM_USADA | Memoria Livre: \$MEM_LIVRE | Bytes Recebidos: \$BYTES_RECEBIDOS | Bytes Transmitidos:  \$BYTES_TRANSMITIDOS </li>" >> /home/ubuntu/relatorio_servico.log

#Jogando dados no index.html
printf "<!DOCTYPE html>" > /var/www/html/index.html
printf "<html lang=\"pt-br\">" >> /var/www/html/index.html
printf "<meta charset="UTF-8"/>" >> /var/www/html/index.html
printf "<head>" >> /var/www/html/index.html
printf "<title>Atividade 16</title>" >> /var/www/html/index.html
printf "</head>" >> /var/www/html/index.html
printf "<body>" >> /var/www/html/index.html
printf "<ol>" >> /var/www/html/index.html
cat /home/ubuntu/relatorio_servico.log >> /var/www/html/index.html
printf "</ol>" >> /var/www/html/index.html
printf "</body>" >> /var/www/html/index.html
printf "</html>" >> /var/www/html/index.html
EOF

#Atribuindo permições
chmod 744 /usr/local/bin/servico.sh
 
#Agendando execução do serviço
echo "*/1 * * * * root /usr/local/bin/servico.sh" >> /etc/crontab

#Reiniciando cron
/etc/init.d/cron restart

#Reiniciando Apache
systemctl restart apache2.service