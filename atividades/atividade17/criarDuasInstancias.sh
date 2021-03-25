

#Formato de entrada/saida
#./criarDuasInstancias.sh nomedachave usuario senha
#Criando servidor de Banco de Dados...
#IP Privado do Banco de Dados: 172.31.64.108

#Criando servidor de Aplicação...
#IP Público do Servidor de Aplicação: 100.25.42.191

#!/bin/bash
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
mysql<<EOF
CREATE DATABASE scripts;
CREATE USER '$USUARIO'@'%' IDENTIFIED BY '$SENHA';
GRANT ALL PRIVILEGES ON scripts.* TO '$USUARIO'@'%';
quit;
EOF
echo "EOF" >> confg_serv.sh
chmod +x confg_serv.sh


#Identificando Subnet
SUBRED_ID=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)

#Criando grupo de segurança
GRUPO=$(aws ec2 create-security-group --group-name "grupo01" --description "grupo01" --output text)

#Identificando IP publico!
IP_ORIGEM=$(curl ifconfig.me)

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

#Acessando banco
mysql -u $USUARIO -p$SENHA -h $IP_PRIVADO_01<<EOF
USE scripts;
CREATE TABLE Teste (atividade INT);
quit;
EOF

echo "EOF" >> confg_cli.sh

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
rm confg_serv.sh

#Recuperando IP publico
IP_PUBLICO_02=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].PublicIpAddress" --output text)
IP_PRIVADO_02=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA_02 --query "Reservations[0].Instances[].PrivateIpAddress" --output text)

#Mostrando endereço do servidor
echo "IP Público do Servidor de Aplicação: $IP_PUBLICO_02"

#Removendo arquivos de configuração
rm -rf confg_cli.sh confg_serv.sh