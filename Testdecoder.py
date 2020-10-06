

def decryption(C,D,N):
	res = (C**D) % N;
	return res
	#print(res);


def decoder(height,width,D,N):
	input_image_file = open("files/Imagen.txt", "r")
	output_image_file = open("files/OutputImage","w")
	data = input_image_file.read();
	a = 0
	for number in map(int, data.split()):
		if(a):
			val = val + number
			print(val)
			toSave = str(decryption(val,D,N)) + " "
			output_image_file.write(toSave)
		else:
			val = number *256
		a = (a + 1)%2
	print(val)
	#close(input_image_file);
	#close(output_image_file);





decoder(640,480,3163,3599)

