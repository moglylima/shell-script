#!/bin/bash

#Linhas linhas que nao sao do sshd
grep -v 'sshd' /home/compartilhado/auth.log.1

#Logins com SSH (2 comando para o mesmo resultado)
grep -E '*\(sshd:session\): session opened*' /home/compartilhado/auth.log.1

grep -E 'sshd.*opened' /home/compartilhado/auth.log.1

#Tentativas de Logins via root
grep 'Disconnected from authenticating user root' /home/compartilhado/auth.log.1

#Login com sucesso no dia 04 de dezembro, entre as 18:00 e 19:00
