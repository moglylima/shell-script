#Correção: OK

BEGIN{
	QTD = 0
}

/@gmail.com/ {
        QTD = QTD + 1
}

END{
	printf "Alunos com e-mail no domínio gmail -> %d no total\n", QTD
}

