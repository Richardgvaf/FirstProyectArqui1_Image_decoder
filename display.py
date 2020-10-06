import matplotlib.pyplot as plt
import numpy as np
def display(width,height):
	decode_image = open("files/OutputImage","r")
	data = decode_image.read();
	matriz = np.zeros((width,height))
	cont=0
	for number in map(int, data.split()):
		row    = cont // height 
		column      = cont % height
		print(row)
		matriz[row][column] = number
		cont += 1
	print(cont)
	plt.imshow(matriz,vmin=0,vmax=255)
	plt.show()
	print(matriz)
	print("everything is ok")

display(640,480)