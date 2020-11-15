import matplotlib.pyplot as plt
import numpy as np

def readBinary():
	data_name = "files/OutputImage2.txt"
	archivo = open(data_name,'rb')
	numeros = archivo.read().split()
	print(len(numeros))
	return(numeros)

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