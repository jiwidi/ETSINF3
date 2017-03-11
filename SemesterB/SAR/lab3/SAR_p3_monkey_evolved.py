from collections import defaultdict
from operator import itemgetter
import sys
import ast
import pickle
import re
def load_object(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
    return obj

def main():
    diccionario=load_object(sys.argv[1])




main()