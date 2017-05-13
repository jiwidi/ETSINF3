import sys
import os
import pickle

def procces(s):
    nonAlphanumericalCharacters= ['!','¡', '@' ,'#','&' ,'(', ')', '–','-', '[', '{', '}', ']', ':', ';', "'",',', '?','¿','/' ,'*','"','.']
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
            Ntext=procces(Nrawtext)
            z=Ntext.split()
            for term in z:
                if term in list(postingList.keys()):
                    if newid not in postingList[term]:
                        postingList[term].append(newid)
                else:
                    postingList[term]=[newid]
        aux.close()
    save_object(postingList,finalName)
    sys.exit()

main()
