
def decryption(C,D,N):
	numCicle = len(D) - 1
	#print(D[numCicle])
	if(D[numCicle] == "1"):
		resParcial = C % N
	else:
		resParcial = 1;
	while(numCicle > 0):
		numCicle -= 1
		#print("Base: ",C)
		#print("resParcial: ",resParcial)
		C = (C**(2)) % N 
		#print(D[numCicle])
		if(D[numCicle] == "1"):
			
			resParcial = (resParcial * C) % N


	#print("Base: ",C)
	#print("resParcial: ",resParcial)
	return resParcial
	#print(res);

def binarizar(decimal):
    binario = ''
    while decimal // 2 != 0:
        binario = str(decimal % 2) + binario
        decimal = decimal // 2
    return str(decimal) + binario
#print(binarizar(53))
#print(str(decryption(4,binarizar(53),31)))

def decoder(height,width,D,N):
	input_image_file = open("files/Imagen.txt", "r")
	output_image_file = open("files/OutputImage2","w")
	data = input_image_file.read();
	a = 0
	for number in map(int, data.split()):
		if(a):
			val = val + number
			print(val)
			toSave = str(decryption(val,binarizar(D),N)) + " "
			output_image_file.write(toSave)
		else:
			val = number *256
		a = (a + 1)%2
	#print(val)
	#close(input_image_file);
	#close(output_image_file);





decoder(640,480,3163,3599)