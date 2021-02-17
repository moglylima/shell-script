BEGIN{
    print "Conexões realizadas via SSH"
}  

/sshd[[[:digit:]]*]:[[:space:]]Accepted/ {
	print
}