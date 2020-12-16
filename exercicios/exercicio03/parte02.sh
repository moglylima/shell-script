#!/bin/bash
cat compras.txt | cut -f2 -d' ' | tr -s '\n' '+'
