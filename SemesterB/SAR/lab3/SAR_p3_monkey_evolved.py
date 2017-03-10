from collections import defaultdict
from operator import itemgetter
import sys
import ast
import pickle
import re
def main():
    parameters=sys.argv
    input=open(parameters[1],'r').read()
    rows=list(filter(lambda x: x!='',input.split("\n")))
    for row in rows:
        row = row.split('  ')
        diccionario = {}
        diccionario = defaultdict(lambda: [0, {}], diccionario)
        diccionario[row[0]]= [row[1],ast.literal_eval(row[2])]
        print(str(diccionario[row[0]][1]))




main()