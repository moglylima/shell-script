#!/bin/bash
# Correção: Até o comando 03.
cat compras.txt | cut -f2 -d' ' | tr -s '\n' '+'
