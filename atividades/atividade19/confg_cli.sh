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

mysql -u alu -p123alu456 -h scripts.cpqttf6pwkwv.us-east-1.rds.amazonaws.com<<EOF1
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
a2enmod rewrite
a2ensite wordpress
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch wordpress/.htaccess
cp -a wordpress/. /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
systemctl restart apache2
cat<<EOF1 > /var/www/html/wordpress/wp-config.php
<?php
define( 'DB_NAME', 'DBwordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', '123wordpress456' );
define( 'DB_HOST', 'scripts.cpqttf6pwkwv.us-east-1.rds.amazonaws.com' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
--table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
}
require_once ABSPATH . 'wp-settings.php';
EOF1
sed -i "s/--/$/g" /var/www/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
systemctl restart apache2
