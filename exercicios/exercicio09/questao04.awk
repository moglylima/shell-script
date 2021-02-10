BEGIN{
	SOMA = 0
}

$2 > 5000{
	SOMA = SOMA + $2
}

END{
	printf "R$ %d\n", SOMA
}
