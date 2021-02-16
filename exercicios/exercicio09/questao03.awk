BEGIN{
	print"Alterando domínio @gmail por @alu"
}


/@/{gsub(/@*/, "@alu.ufc.br")
	print
}

END{
	print"OK..."
}
