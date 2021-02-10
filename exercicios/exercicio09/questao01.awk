BEGIN{
	print "Alunos no dominio @alu.ufc.br"
}

/@alu.ufc.br/ {
	print
}

end{
}
