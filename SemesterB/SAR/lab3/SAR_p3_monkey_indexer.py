from collections import defaultdict
import sys
import pickle
def sort_subDicc(diccionario):
    r=""
    for key,value in sorted(diccionario.items()):
        r+='('+key+','+"'"+str(value)+"'"+'), '
    r=r[:len(r)-2]
    r='['+r+']'
    return r
def print_dicc(diccionario):
    f = open(sys.argv[2], 'w')
    for key, value in sorted(diccionario.items()):
        cont=value[0]
        dic=value[1]
        f.write(key+'  '+str(cont)+'  '+sort_subDicc(dic)+'\n')
        print('      ',key,cont,sort_subDicc(dic))

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
    frases = list(filter(lambda x: x!='',input.split('\n')))
    for idx, frase in enumerate(frases):
        frases[idx] = '$ ' + frase +' $'
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
