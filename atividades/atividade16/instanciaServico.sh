#!/bin/bash
# ATENÇÃO: mesmo em um repositório privado e sendo uma chave temporária, nunca carrege um 
# arquivo .pem no GitHub.
echo "Criando servidor de Monitoramento em CRON..."

#Chave
CHAVE=$1

#Variáveis fixas
IMAGEM_AMI="ami-042e8287309f5df03"
TIPO_INSTANCIA="t2.micro"


#Identificando Subnet
SUBRED_ID=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)

#Criando grupo de segurança
GRUPO=$(aws ec2 create-security-group --group-name "grupo01" --description "grupo01" --output text)

#Definindo politicas do grupo(Liberando portas 22,80)
aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 80 --cidr 0.0.0.0/0

#Criando instancia
ID_INSTANCIA=$(aws ec2 run-instances --image-id $IMAGEM_AMI --instance-type $TIPO_INSTANCIA --security-group-ids $GRUPO --subnet-id $SUBRED_ID --key-name $CHAVE --user-data file://confg_serv.sh --query "Instances[0].InstanceId" --output text)

#Verificando status da instancia
#STATE=$(aws ec2 describe-instances --query "Reservations[0].Instances[0].State.Name" --output text)

STATE=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA --query "Reservations[0].Instances[].State.Name" --output text)

while [ $STATE != "running"  ]
do
	sleep 10
	STATE=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA --query "Reservations[0].Instances[].State.Name" --output text)

done

echo "Instância em estado running"

#Recuperando IP publico
IP_PUBLICO=$(aws ec2 describe-instances --instance-id $ID_INSTANCIA --query "Reservations[0].Instances[].PublicIpAddress" --output text)

#Mostrando endereço do servidor
echo "Acesse -> http://$IP_PUBLICO/"
