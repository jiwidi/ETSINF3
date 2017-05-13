import sys
import os
import pickle

def save_object(object, file_name):
    with open(file_name, 'wb') as fh:
        pickle.dump(object, fh)

def main():
    postingList={}
    save_object(postingList,sys.argv[1])
    print(str(postingList))
    






main()