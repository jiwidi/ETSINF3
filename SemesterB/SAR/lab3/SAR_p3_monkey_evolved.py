from collections import defaultdict
from operator import itemgetter
import sys
import ast
import random
import pickle
import re
def load_object(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
    return obj
def generateSentences(diccionario,count,length):
    output = open(sys.argv[2], 'w')
    for m in range(count):
        text='$ '
        pal='$'
        for n in range(length):
            pal=generateWord(diccionario[pal][1])
            text+=pal+' '
            if(pal=='$'):
                break
        output.write(text+'\n')
def generateWord(diccionario):
    keys=diccionario.keys()
    list=[]
    for key in keys:
        for n in range(diccionario[key]):
            list.append(key)
    return random.choice(list)
def main():
    diccionario=load_object(sys.argv[1])
    generateSentences(diccionario,10,25)




main()