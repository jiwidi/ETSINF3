from collections import defaultdict
from operator import itemgetter
import sys
import pickle
import re
def print_dicc(diccionario):
    for key, value in sorted(diccionario.items()):
        cont=value[0]
        dic=value[1]
        print('      ',key,cont,str(["%s,%s" %(key,value) for (key,value) in sorted(dic.items(), key=itemgetter(1), reverse=True)]))

def save_object(object, file_name):
    with open(file_name, 'wb') as fh:
        pickle.dump(object, fh)

def main():
    signos= (".", ",", ";", "?", "!",'"',"'",":","(",")")
    parameters = sys.argv
    input = open(parameters[1], 'r').read()
    frases = list(filter(lambda x: x!='',re.split('\.|\n\n ',input)))
    for idx, frase in enumerate(frases):
        frases[idx] = ' $ ' + frase +' $ '
    diccionario = {}
    for frase in frases:
        palabras = frase.split()
        for idx, palabra in enumerate(palabras):
            for k in range(len(palabra)):
                if palabra[k] in signos:
                    palabras[idx] = palabra[:k].lower().strip()+palabra[k+1:].lower().strip()
                else:
                    palabras[idx]=palabra.lower().strip()
        for idx, palabra in enumerate(palabras):
            if(palabra in diccionario.keys()):
                diccionario[palabra][0] += 1
            else:
                diccionario[palabra]=[1,{}]
            if(idx < len(palabras)-1):
                if(palabras[idx + 1] in diccionario[palabra][1].keys()):
                    diccionario[palabra][1][palabras[idx + 1]] += 1
                else:
                    diccionario[palabra][1][palabras[idx + 1]] =1
    save_object(diccionario,parameters[2])



main()
