import sys
import pickle
from collections import defauldict
def save_object(object, file_name):
	with open(file_name, ’wb’) as fh:
		pickle.dump(object, fh)
def load_object(file_name):
	with open(file_name, ’rb’) as fh:
		obj = pickle.load(fh)
	return obj
def main():
    parameters=sys.argv
    input=open(parameters[1],'r').read()
	frases=input.split('\n')
	for idx,frase in enumerable(frases):
		frases[idx]='$'+frase
	diccionario={}
	diccionario=defaultdict(lambda: [0,defaultdict(0)], diccionario)
	for frase in frases:
		palabras=frase.split()
		for idx,palabra in enumerable(palabras):
			diccionario[palabra][0]+=1
			diccionario[palabra][1][palabras[idx+1]]+=1
	
	
main()