#!/bin/bash

#criando diretorio
mkdir maiorque10

#buscando e movendo arquivos maior que 10mb
find . -size +10M -exec mv {}  maiorque10/ 

#compactando arquivos
tar -czf maiorque10.tar.gz maiorque10/

#removendo pasta maiorque10
rm -rf maiorque10/
