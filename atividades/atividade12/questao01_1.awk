BEGIN{
    print "Busca tudo que é diferente de SSHD"
}
! /sshd/ {
	print
}

