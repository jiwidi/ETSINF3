import sys
import os

def procces(s):
    nonAlphanumericalCharacters= ['!', '@' ,'#','&' ,'(', ')', '–', '[', '{', '}', ']', ':', ';', "'",',', '?' ,'/' ,'*','"','.']
    for character in nonAlphanumericalCharacters:
        s=s.replace(character, '')
    s=s.lower()
    return s

def main():
    direc=sys.argv[1]
    postingList={}
    finalName=sys.argv[2]
    for filename in os.listdir(direc):
        print(filename)
        aux=open(direc+'/'+filename,'r')
        raw=aux.read()
        rawlist=raw.split('<DOC>')
        for new in range(1,len(rawlist)):
            Nid=rawlist[new][rawlist[new].find('<DOCID>')+len('<DOCID>'):rawlist[new].find('</DOCID>')]
            Nrawtext=rawlist[new][rawlist[new].find('<TEXT>')+len('<TEXT>'):rawlist[new].find('</TEXT>')]
            Ntext=procces(Nrawtext)
            z=Ntext.split()
            for w in z:
                if w in list(postingList.keys()):
                    postingList[w].append([Nid])
                else:
                    postingList[w]=[Nid]
        aux.close()
        sys.exit()
    for key in list(postingList.keys()):
        print(key+'   '+str(postingList[key]))

main()