BEGIN{
    print "Iniciando"
}

/home\/alunos/{
    gsub(/home\/alunos/, "home\/alunos")
    print
}
