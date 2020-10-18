import matplotlib.pyplot as plt
import numpy as np

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

def display(width,height):
	lista = readBinary()
	matriz = np.zeros((width,height))
	cont=0
	for number in lista:
		row    = cont // height 
		column      = cont % height
		matriz[row][column] = number
		cont += 1
	print(cont)
	plt.imshow(matriz,cmap='gray')
	plt.show()
	print(matriz)
	print("everything is ok")

display(640,480)