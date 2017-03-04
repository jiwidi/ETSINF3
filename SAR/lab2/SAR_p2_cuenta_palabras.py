#! -*- encoding: utf8 -*-
# inspired by Lluís Ulzurrun and Víctor Grau work

from operator import itemgetter
from collections import Counter
from collections import OrderedDict
import re
import sys

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def sort_dicFr(d):
    for key, value in sorted(sorted(d.items()), key=itemgetter(1), reverse=True):
        print('      ',key,value)
        #yield key, value
def sort_dicA(d):
    for key, value in sorted(d.items()):
        print('      ',key,value)
def text_statistics(filename, to_lower=True, remove_stopwords=True):
    file=open(filename,'r')
    stopwords=open('stopwords_en.txt','r')
    listaSwords=stopwords.read().split('\n')
    texto=file.read()
    nlineas=len(list(filter(lambda x: x!='',texto.split('\n'))))
    palabras=texto.split()
    signos = (".", ",", ";", "?", "!")
    for idx,palabra in enumerate(palabras):
        if(to_lower):
            palabras[idx]=palabra.lower()
    for idx, palabra in enumerate(palabras):
        if palabra[len(palabra)-1] in signos:
            palabras[idx]=palabra[:len(palabra)-1]
    npalabras=len(palabras)
    if(remove_stopwords):
        npalabrassw=0
        for palabra in palabras:
            if(palabra not in listaSwords):
                npalabrassw=+1
    vocabulario=len(set(palabras))
    letras = list(filter(lambda x: x.isalpha(), texto))
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
    print('Words (alphabetical order):')
    sort_dicA(diccionario)
    print('Words (frequency order):')
    sort_dicFr(diccionario)
    diccionarioLetras=Counter(letras)
    print('Symbols (alphabetical order')
    sort_dicA(diccionarioLetras)
    print('Symbols (frequency order):')
    sort_dicFr(diccionarioLetras)
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
