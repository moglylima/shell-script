#!/bin/bash
#Atualizando repositórios
apt-get update

#Instalando cliente mysql
apt-get install -y mysql-client

#Adicionando arquivo com credenciais
echo "[client]" > ~/.my.cnf
echo "user=alu" >> ~/.my.cnf
echo "password=123alu456" >> ~/.my.cnf

#Install módulos
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

#Acessando banco
mysql -u alu -p123alu456 -h 172.31.61.191<<EOF
USE scripts;
CREATE TABLE Teste (atividade INT);
quit;
EOF
cat<<EOF > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
EOF
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
