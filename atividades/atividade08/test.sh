#!/bin/bash

mkdir teste;

for i in $(seq 10)
do
     ano=$(shuf -e 2009 2010 2011 2012 2013 | tail -n 1);
     mes=$(shuf -e 01 02 03 04 05 06 07 08 09 10 11 12 | tail -n 1);
     dia=$(shuf -e 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 | tail -n 1);
     touch -m -t ${ano}${mes}${dia}0000 teste/arquivo$i.txt
done
