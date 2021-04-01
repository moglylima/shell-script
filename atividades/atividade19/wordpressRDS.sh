
#!/bin/bash
echo "Criando  instância de Banco de Dados no RDS..."

#Parametros recebidos
CHAVE=$1
USUARIO=$2
SENHA=$3

#Variáveis fixas
IMAGEM_AMI="ami-042e8287309f5df03"
TIPO_INSTANCIA="t2.micro"

#Identificando IP publico!
IP_ORIGEM=$(curl -s ifconfig.me)

#Identificando Subnet
SUBRED_ID=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)

#Criando grupo de segurança
GRUPO=$(aws ec2 create-security-group --group-name "scripts" --description "scriptsRDS" --output text)

#Definindo politicas do grupo(Liberando portas 22,80 e 3306)
aws ec2 authorize-security-group-ingress --group-id $GRUPO --port 22 --protocol tcp  --cidr $IP_ORIGEM/32
aws ec2 authorize-security-group-ingress --group-id $GRUPO --port 80 --protocol tcp  --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GRUPO --port 3306 --protocol tcp --source-group $GRUPO

#Criando instancia RDS mysql
aws rds create-db-instance --db-instance-identifier scripts --engine mysql --master-username $USUARIO --master-user-password $SENHA --allocated-storage 20 --no-publicly-accessible --db-subnet-group-name default-vpc-78d67e05 --vpc-security-group-ids $GRUPO --db-instance-class db.t2.micro

#Verificando se a db-instance já está acessível
STATUS_DB=$(aws rds describe-db-instances --query "DBInstances[].DBInstanceStatus" --output text)
while [ $STATUS_DB != "available"  ]
do
	sleep 10
	STATUS_DB=$(aws rds describe-db-instances --query "DBInstances[].DBInstanceStatus" --output text)
done

#Identificando Endpoint Address
ENDPOINT_ADDRESS=$(aws rds describe-db-instances --query "DBInstances[].Endpoint.Address" --output text)
echo "Endpoint do RDS:  $ENDPOINT_ADDRESS"


#Criando Banco scripts


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
echo "user=wordpress" >> ~/.my.cnf
echo "password=123wordpress456" >> ~/.my.cnf

#Install módulos
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

mysql -u $USUARIO -p$SENHA -h $ENDPOINT_ADDRESS<<EOF1
CREATE DATABASE DBwordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY '123wordpress456';
GRANT ALL PRIVILEGES ON DBwordpress.* TO 'wordpress'@'%';
quit;
EOF1

cat<<EOF2 > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
EOF2
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
define( 'DB_NAME', 'DBwordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', '123wordpress456' );
define( 'DB_HOST', '$ENDPOINT_ADDRESS' );
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
IP_PUBLICO_01=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].PublicIpAddress" --output text)

#Mostrando endereço do servidor
echo "Acesse http://$IP_PUBLICO_01/wordpress para finalizar a configuração."

#Removendo arquivos de configuração
#rm -rf confg_cli.sh confg_serv.sh