from collections import defaultdict
from operator import itemgetter
import sys
import pickle
import re
def print_dicc(diccionario):
    f = open(sys.argv[2], 'w')
    for key, value in sorted(diccionario.items()):
        cont=value[0]
        dic=value[1]
        f.write(key+'  '+str(cont)+'  '+str(dic)+'\n')
        print('      ',key,cont,str(["%s,%s" %(key,value) for (key,value) in sorted(dic.items(), key=itemgetter(1), reverse=True)]))

def load_object(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
    return obj
def save_object(object, file_name):
    with open(file_name, 'wb') as fh:
        pickle.dump(object, fh)
def main():
    signos= (".", ",", ";", "?", "!")
    parameters = sys.argv
    input = open(parameters[1], 'r').read()
    #input.replace('\n\n','.')
    frases = list(filter(lambda x: x!='',re.split('\.|\n\n ',input)))
    for idx, frase in enumerate(frases):
        frases[idx] = ' $ ' + frase +' $ '
    diccionario = {}
    diccionario = defaultdict(lambda: [0, {}], diccionario)
    for frase in frases:
        palabras = frase.split()
        for idx, palabra in enumerate(palabras):
            if palabra[len(palabra) - 1] in signos:
                palabras[idx] = palabra[:len(palabra) - 1].lower()
            else:
                palabras[idx]=palabra.lower()
        for idx, palabra in enumerate(palabras):
            diccionario[palabra][0] += 1
            if(idx < len(palabras)-1):
                if(palabras[idx + 1] in diccionario[palabra][1].keys()):
                    diccionario[palabra][1][palabras[idx + 1]] += 1
                else:
                    diccionario[palabra][1][palabras[idx + 1]] =1
    print_dicc(diccionario)



main()
