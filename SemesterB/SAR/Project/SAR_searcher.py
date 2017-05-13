import sys
import os
import pickle

def load_object(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
    return obj

def relevantNews(terms,postingList):
    aux=[]
    result=[]
    terms=terms.split()
    for term in terms:
        if term in list(postingList.keys()):
            pl=postingList[term]
            ids=[c[0] for c in aux]
            for id in pl:
                if id in ids:
                    aux[aux.index(id)]=[[Nid,count+1] for Nid,count in aux and Nid==id]
                else:
                    aux.append(id)
                    aux[aux.index(id)]=[id,1]
        else:
            return []
    return [z[0] for z in aux if z[1]==len(terms)]



def main():
    postingList=load_object(sys.argv[1])
    query=str(sys.argv[2])
    n=relevantNews(query,postingList)
    print(len((n)))






main()