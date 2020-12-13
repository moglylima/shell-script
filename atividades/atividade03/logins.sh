#!/bin/bash

#Linhas linhas que nao sao do sshd
grep -v 'sshd' /home/compartilhado/auth.log.1

#Logins com SSH 
grep -E 'sshd[[[:digit:]]*]:[[:space:]]Accepted' /home/compartilhado/auth.log.1

#Tentativas de Logins via root
grep  'sshd[[[:digit:]]*]:[[:space:]]Connection closed by authenticating user root' /home/compartilhado/auth.log.1

#Login com sucesso no dia 04 de dezembro, entre as 18:00 e 19:00
grep -E 'Dec[[:space:]]*4[[:space:]]*(18.*|19:00.*).*sshd[[[:digit:]]*]:[[:space:]]Accepted' /home/compartilhado/auth.log.1
