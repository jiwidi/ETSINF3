#! -*- encoding: utf8 -*-
# inspired by Lluís Ulzurrun and Víctor Grau work

from operator import itemgetter
from collections import Counter
import re
import sys

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def sort_dic(d):
    for key, value in sorted(sorted(d.items()), key=itemgetter(1), reverse=True):
        yield key, value

def text_statistics(filename, to_lower=True, remove_stopwords=True):
    file=open(filename,'r')
    stopwords=open('stopwords_en.txt','r')
    listaSwords=stopwords.read().split('\n')
    texto=file.read()
    nlineas=len(texto.split('\n'))
    palabras=texto.split(' ')
    signos = (".", ",", ";", "?", "!")
    for idx,palabra in enumerate(palabras):
        if palabra[len(palabra)-1] in signos:
            palabras[idx]=palabra[:len(palabra)-1]
            
    npalabras=len(palabras)
    if(remove_stopwords):
        npalabrassw=0
        for palabra in palabras:
            if(palabra not in listaSwords):
                npalabrassw=+1
    vocabulario=len(set(palabras))
    letras = list(filter(lambda x: x != ' ', texto))
    simbolos=len(letras)
    simbolosDist=len(set(letras))
    diccionario=Counter(palabras)
    print('Lines: '+str(nlineas))
    print('Number of words (with stopwords): '+str(npalabras))
    if(remove_stopwords):
        print('Number of words (without stopwords): '+str(npalabrassw))
    print('Vocabulary size: '+str(vocabulario))
    print('Number of symbols: '+str(simbolos))
    print('Number of different symbols: '+str(simbolosDist))
    for key in diccionario:
        print(key+str(diccionario[key]))



def syntax():
    print ("\n%s filename.txt [to_lower?[remove_stopwords?]\n" % sys.argv[0])
    sys.exit()

def main():
    if len(sys.argv) < 2:
        syntax()
    name = sys.argv[1]
    lower = False
    stop = False
    if len(sys.argv) > 2:
        lower = (sys.argv[2] in ('1', 'True', 'yes'))
        if len(sys.argv) > 3:
            stop = (sys.argv[3] in ('1', 'True', 'yes'))
    text_statistics(name, to_lower=lower, remove_stopwords=stop)
main()
