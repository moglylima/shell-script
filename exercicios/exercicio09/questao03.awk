BEGIN{
	print"Alterando domínio @gmail por @alu"
}


/@gmail.com/{ gsub(/@gmail.com/, "@alu.ufc.br"); print }

END{
	print"OK..."
}



