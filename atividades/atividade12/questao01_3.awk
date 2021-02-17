BEGIN{
    print "Conexões com toot"
}  
/sshd[[[:digit:]]*]:[[:space:]]Connection closed by authenticating user root/ {
	print
}