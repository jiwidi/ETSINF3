import sys
import os
import pickle
from nltk.corpus import stopwords
from nltk import word_tokenize
from nltk.stem import SnowballStemmer

def process(s):
    #Delete non alphanumerical characters
    for character in s:
        if not character.isalpha():
            s=s.replace(character, ' ')
    s=s.lower()
    return s

def save_object(object, file_name):
    with open(file_name, 'wb') as fh:
        pickle.dump(object, fh)

def stemList(z,stemmer):
    diccStem={}
    for term in z:
        resul=stemmer.stem(term)
        l = diccStem.get(resul, [])
        l.append(term)
        diccStem[resul] = l
    return diccStem


def main():
    print('Starting indexation')
    direc=sys.argv[1]
    dictDoc={}
    postingList={}
    finalName=sys.argv[2]
    docid=0
    for filename in sorted(os.listdir(direc)):
        docid+=1
        print('Indexing file: '+filename)
        dictDoc[filename]=docid
        aux=open(direc+'/'+filename,'r')
        raw=aux.read()
        rawlist=raw.split('<DOC>')
        nnew=0
        for new in range(1,len(rawlist)):
            nnew+=1
            newid=[docid,nnew]
            Nrawtext=rawlist[new][rawlist[new].find('<TEXT>')+len('<TEXT>'):rawlist[new].find('</TEXT>')]
            Ntext=process(Nrawtext)
            z=Ntext.split()
            for term in z:
                l = postingList.get(term, [])
                l.append(newid)
                postingList[term] = l
        aux.close()
    print("Stemming...  ")
    keys=list(postingList.keys())
    stemmer = SnowballStemmer('spanish')
    stemmingDicc = stemList(keys, stemmer)
    postingListStem = {}
    for k in stemmingDicc:
        newPL=[]
        for w in stemmingDicc[k]:
            for e in postingList[w]:
                if e not in newPL:
                    newPL.append(e)
        for ww in stemmingDicc[k]:
            postingListStem[ww] = newPL
    print("Done")
    save_object((postingList,postingListStem),finalName)
    sys.exit()

main()
