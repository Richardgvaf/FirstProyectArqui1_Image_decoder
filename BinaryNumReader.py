def readBinary():
	data_name = "files/output_decryption.txt"
	archivo = open(data_name,'rb')
	numeros = list(archivo.read())
	cont = 0
	x =  0
	lista = []
	for i in numeros:
		if(cont == 0):
			x = i
		if(cont == 1):
			x = x + i*256
		if(cont == 2):
			x = x + i*256
		if(cont == 3):
			x = x + i*256
			lista.append(x)
		cont = (cont + 1)%4

	return(lista)

readBinary()