import sys
import os
import pickle

def process(s,stopwords,stemming):
    nonAlphanumericalCharacters= ['+','!','¡', '@' ,'#','&' ,'(', ')', '–','-', '[', '{', '}', ']', ':', ';', "'",',', '?','¿','/' ,'*','"','.']
    for character in nonAlphanumericalCharacters:
        s=s.replace(character, ' ')
    s=s.lower()
    return s

def save_object(object, file_name):
    with open(file_name, 'wb') as fh:
        pickle.dump(object, fh)



def main():
    direc=sys.argv[1]
    dictDoc={}
    postingList={}
    finalName=sys.argv[2]
    stopwords=False
    stemming=False
    if '-s' in sys.argv:
        print("Deleting stopwords")
        stopwords=True
    if '-t' in sys.argv:
        print("Stemming")
        stemming=True
    docid=0
    for filename in sorted(os.listdir(direc)):
        docid+=1
        print(filename)
        dictDoc[filename]=docid
        aux=open(direc+'/'+filename,'r')
        raw=aux.read()
        rawlist=raw.split('<DOC>')
        nnew=0
        for new in range(1,len(rawlist)):
            nnew+=1
            newid=[docid,nnew]
            Nrawtext=rawlist[new][rawlist[new].find('<TEXT>')+len('<TEXT>'):rawlist[new].find('</TEXT>')]
            Ntext=process(Nrawtext,stopwords,stemming)
            z=Ntext.split()
            if (stopwords):
                stopwordsEN = open('stopwords_en.txt', 'r')
                listaSwordsEN = stopwordsEN.read().split('\n')
                stopwordsES = open('stopwords_en.txt', 'r')
                listaSwordsES = stopwordsES.read().split('\n')
                listaSwords=listaSwordsEN+listaSwordsES
                z = list(filter(lambda x: x not in listaSwords, z))
            for term in z:
                l = postingList.get(term, [])
                l.append(newid)
                postingList[term] = l
                #print(l)
                #sys.exit(0)
                #if term in postingList:
                #    if newid not in postingList[term]:
                 #       postingList[term].append(newid)
                #else:
                #    postingList[term]=[newid]
        aux.close()
    save_object(postingList,finalName)
    sys.exit()

main()
