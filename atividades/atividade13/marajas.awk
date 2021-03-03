function qtd(a){
        k = 0
        for(x in a){
                k++
        }
        return k
}


BEGIN{
	i = 2
}

{
	linha[i] = split($NF " " $(NF - 1)" " $(NF - 2), linha, " ")
	}

END{
	print linha[::]
}
