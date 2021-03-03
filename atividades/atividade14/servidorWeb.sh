#!/bin/bash

echo "Criando Servidor..."

IMAGEM_AMI="ami-042e8287309f5df03"

SUBRED_ID=`aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text`

#Criando grupo de segurança
#aws ec2 create-security-group --group-name "name" --description "Description test" --output text

GRUPO_ID_01=`aws ec2 create-security-group --group-name "grupo_01" --description "grupo_01" --output text`
GRUPO_ID_02=`aws ec2 create-security-group --group-name "grupo_02" --description "grupo_02" --output text`


aws ec2 authorize-security-group-ingress --group-id sg-0fb9c2e41783c4da1 --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id sg-0fb9c2e41783c4da1 --protocol tcp --port 80 --cidr 0.0.0.0/0

echo "Acesse: "
