#! -*- encoding: utf8 -*-
# inspired by Lluís Ulzurrun and Víctor Grau work

from operator import itemgetter
from collections import Counter
from collections import defaultdict
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
    frases=list(filter(lambda x: x!='',texto.split('\n')))
    nlineas=len(frases)
    palabras=texto.split()
    signos = (".", ",", ";", "?", "!")
    for idx, palabra in enumerate(palabras):
        if palabra[len(palabra)-1] in signos:
            palabras[idx]=palabra[:len(palabra)-1]
        if(to_lower):
            palabras[idx]=palabras[idx].lower()
    npalabras=len(palabras)
    if(remove_stopwords):
        palabras=list(filter(lambda x: x not in listaSwords,palabras))
    npalabrassw=len(palabras)
    vocabulario=set(palabras)
    nvocabulario=len(set(palabras))
    letras = list(filter(lambda x: x.isalpha(), "".join(palabras)))
    simbolos=len(letras)
    simbolosDist=len(set(letras))
    diccionario=Counter(palabras)
    print('Lines: '+str(nlineas))
    print('Number of words (with stopwords): '+str(npalabras))
    if(remove_stopwords):
        print('Number of words (without stopwords): '+str(npalabrassw))
    print('Vocabulary size: '+str(nvocabulario))
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
    #Ampliacion
    for idx,frase in enumerate(frases):
        diccionarioBigramas = {}
        diccionarioBigramas = defaultdict(lambda: 0, diccionarioBigramas)
        frase='$ '+frase+' $'
        palabrasF=frase.split()
        for counter in range(len(palabrasF)-1):
            diccionarioBigramas[palabrasF[counter]+' + '+palabrasF[counter+1]]+=1
        print('Analysis of bigrams from sentence: '+str(idx)+' (alphabetical order)')
        sort_dicA(diccionarioBigramas)
        print('Analysis of bigrams from sentence: '+str(idx)+' (frequency order)')
        sort_dicFr(diccionarioBigramas)
    for idx,palabra in enumerate(vocabulario):
        diccionarioBigramas = {}
        diccionarioBigramas = defaultdict(lambda: 0, diccionarioBigramas)
        for counter in range(len(palabra)-1):
            diccionarioBigramas[palabra[counter]+' + '+palabra[counter+1]]+=1
        print('Analysis of bigrams from word: '+palabra+' (alphabetical order)')
        sort_dicA(diccionarioBigramas)
        print('Analysis of bigrams from word: '+palabra+' (frequency order)')
        sort_dicFr(diccionarioBigramas)

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
