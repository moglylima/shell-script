
#!/bin/bash
# Correção: 2,5
echo "Criando servidor de Banco de Dados..."

#Parametros recebidos
CHAVE=$1
USUARIO=$2
SENHA=$3

#Variáveis fixas
IMAGEM_AMI="ami-042e8287309f5df03"
TIPO_INSTANCIA="t2.micro"

#Gerando arquivo de configuração servidor
cat << EOF > confg_serv.sh
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
CREATE USER '$USUARIO'@'%' IDENTIFIED BY '$SENHA';
GRANT ALL PRIVILEGES ON scripts.* TO '$USUARIO'@'%';
quit;
EOF2

EOF
chmod +x confg_serv.sh


#Identificando Subnet
SUBRED_ID=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)

#Criando grupo de segurança
GRUPO=$(aws ec2 create-security-group --group-name "grupo01" --description "grupo01" --output text)

#Identificando IP publico!
IP_ORIGEM=$(curl -s ifconfig.me)

#Definindo politicas do grupo(Liberando portas 22,80)
aws ec2 authorize-security-group-ingress --group-id $GRUPO --port 22 --protocol tcp  --cidr $IP_ORIGEM/32
aws ec2 authorize-security-group-ingress --group-id $GRUPO --port 80 --protocol tcp  --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $GRUPO --port 3306 --protocol tcp --source-group $GRUPO

#Criando instancia
ID_INSTANCIA_01=$(aws ec2 run-instances --image-id $IMAGEM_AMI --instance-type $TIPO_INSTANCIA --security-group-ids $GRUPO --subnet-id $SUBRED_ID --key-name $CHAVE --user-data file://confg_serv.sh --query "Instances[0].InstanceId" --output text)

#Verificando status da instancia
STATE_01=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_01 --query "Reservations[0].Instances[].State.Name" --output text)

while [ $STATE_01 != "running"  ]
do
	sleep 10
	STATE_01=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_01 --query "Reservations[0].Instances[].State.Name" --output text)

done

echo "Servirdor de banco de dados em estado running"

#Recuperando IP publico
IP_PUBLICO_01=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_01 --query "Reservations[0].Instances[].PublicIpAddress" --output text)
IP_PRIVADO_01=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_01 --query "Reservations[0].Instances[].PrivateIpAddress" --output text)

#Mostrando endereço do servidor
echo "IP Privado do Banco de Dados: $IP_PRIVADO_01"

sleep 100
#--------------------------------------------------
#Cliente
#Gerando arquivo de configuração cliente
cat << EOF > confg_cli.sh
#!/bin/bash
#Atualizando repositórios
apt-get update
#Instalando cliente mysql
apt-get install -y mysql-client
#Adicionando arquivo com credenciais
echo "[client]" > ~/.my.cnf
echo "user=$USUARIO" >> ~/.my.cnf
echo "password=$SENHA" >> ~/.my.cnf
#Install módulos
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
#Acessando banco
mysql -u $USUARIO -p$SENHA -h $IP_PRIVADO_01<<EOF1
USE scripts;
CREATE TABLE Teste (atividade INT);
quit;
EOF1
EOF

cat << EOF >> confg_cli.sh
cat<<EOF1 > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
EOF1
EOF

echo "a2enmod rewrite" >> confg_cli.sh
echo "a2ensite wordpress" >> confg_cli.sh

cat << EOF >> confg_cli.sh
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch wordpress/.htaccess
cp -a wordpress/. /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
systemctl restart apache2
EOF


cat << EOF >> confg_cli.sh

cat<<EOF1 > /var/www/html/wordpress/wp-config.php
<?php
define( 'DB_NAME', 'scripts' );
define( 'DB_USER', '$USUARIO' );
define( 'DB_PASSWORD', '$SENHA' );
define( 'DB_HOST', '$IP_PRIVADO_01' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
\$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
--table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
}
require_once ABSPATH . 'wp-settings.php';
EOF1
EOF


cat << EOF >> confg_cli.sh
sed -i "s/--/\$/g" /var/www/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
systemctl restart apache2
EOF

chmod +x confg_cli.sh

echo "Criando servidor de Aplicação..."
#Criando instancia
ID_INSTANCIA_02=$(aws ec2 run-instances --image-id $IMAGEM_AMI --instance-type $TIPO_INSTANCIA --security-group-ids $GRUPO --subnet-id $SUBRED_ID --key-name $CHAVE --user-data file://confg_cli.sh --query "Instances[0].InstanceId" --output text)

#Verificando status da instancia
STATE_02=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].State.Name" --output text)

while [ $STATE_02 != "running"  ]
do
	sleep 10
	STATE_02=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].State.Name" --output text)

done

echo "Servirdor de aplicação em estado running"

#Recuperando IP publico
IP_PUBLICO_02=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].PublicIpAddress" --output text)
IP_PRIVADO_02=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].PrivateIpAddress" --output text)

#Mostrando endereço do servidor
echo "Acesse http://$IP_PUBLICO_02/wordpress para finalizar a configuração."

#Removendo arquivos de configuração
rm -rf confg_cli.sh confg_serv.sh
