#!/bin/bash
# Correção: OK.
echo -e "Olá $(whoami), \nHoje é dia $(date '+%d'), do mês $(date '+%m') do ano de $(date '+%Y'). " | tee -a  saudacao.log
