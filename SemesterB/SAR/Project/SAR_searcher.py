import sys
import os
import pickle

def process(s):
    #nonAlphanumericalCharacters= ['1','2','3','4','5','6','7','8','9''0','+','!','¡', '@' ,'#','&' ,'(', ')', '–','-', '[', '{', '}', ']', ':', ';', "'",',', '?','¿','/' ,'*','"','.']
    for character in s:
        if not s.isalpha():
            s=s.replace(character, ' ')
    s=s.lower()
    return s

def load_object(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
    return obj

def relevantNews(term,postingList):
    if term in list(postingList.keys()):
        return postingList[term]
    else:
        return []


def applyOperator(list1,list2,operator,sign,postingList,buffer):
    c=[]
    if operator=='AND':
        if sign=='YES':
            c=intersec(list1,list2)
        elif sign == 'NOT':
            c=andnot(list1,list2)
    return c


def intersec(list1,list2):
    c=[]
    jj = 0
    kk = 0
    list1 = sorted(list1)
    list2 = sorted(list2)
    while jj < len(list1) and kk < len(list2):
        if list1[jj] == list2[kk]:
            c.append(list1[jj])
            jj += 1
            kk += 1
        else:
            if list1[jj][0] < list2[kk][0]:
                jj += 1
            elif list1[jj][0] == list2[kk][0]:
                if list1[jj][1] < list2[kk][1]:
                    jj += 1
                else:
                    kk += 1
            else:
                kk += 1
    return c


def andnot(list1, list2):
    c = []
    jj = 0
    kk = 0
    list1 = sorted(list1)
    list2 = sorted(list2)
    while jj < len(list1) and kk < len(list2):
        if list1[jj] == list2[kk]:
            jj += 1
            kk += 1
        else:
            if list1[jj][0] < list2[kk][0]:
                c.append(list1[jj])
                jj += 1
            elif list1[jj][0] == list2[kk][0]:
                if list1[jj][1] < list2[kk][1]:
                    c.append(list1[jj])
                    jj += 1
                else:
                    kk += 1
            else:
                kk += 1
    while jj < len(list1):
        c.append(list1[jj])
        jj += 1

    return c
def showResult(relevant,query):
    print(len(relevant))
    print(relevant)
    if sys.argv[1] == "e":
        direc = "enero/"
    elif sys.argv[1] == "me":
        direc = "mini_enero/"
    files = sorted(os.listdir(direc))

    if len(relevant)<=2:
        #print(files)
        #print(relevant)
        for entry in relevant:
            aux = open(direc+'/'+files[entry[0]-1])
            raw = aux.read()
            rawlist = raw.split('<DOC>')
            index = entry[1]
            Nrawtitle = rawlist[index][rawlist[index].find('<TITLE>') + len('<TITLE>'):rawlist[index].find('</TITLE>')]
            print(Nrawtitle)
            Nrawtext = rawlist[index][rawlist[index].find('<TEXT>') + len('<TEXT>'):rawlist[index].find('</TEXT>')]
            print(Nrawtext + '\n\n')

    elif len(relevant)>5:
        #print(files)
        #print(relevant)
        lrel = len(relevant)
        if lrel>10:
            lrel = 10
        for doc in range(0,(lrel-1)):
            entry = relevant[doc]
            aux = open(direc+'/'+files[entry[0]-1])
            raw = aux.read()
            rawlist = raw.split('<DOC>')
            index = entry[1]
            num = 0
            Nrawtitle = rawlist[index][rawlist[index].find('<TITLE>') + len('<TITLE>'):rawlist[index].find('</TITLE>')]
            print(Nrawtitle)
            num += 1

    else:
        newquery = []
        lenq = len(query)
        query.insert(0, 'OR')
        k = 1
        while k <= lenq:
            if (query[k] != 'AND' and query[k] != 'OR' and query[k] != 'NOT'):
                if (query[k - 1] != 'NOT'):
                    newquery.append(query[k])
            k = k + 1
        l=0
        for entry in relevant:
            l+=1
            aux = open(direc + '/' + files[entry[0] - 1])
            raw = aux.read()
            rawlist = raw.split('<DOC>')
            index = entry[1]
            Nrawtext = rawlist[index][rawlist[index].find('<TEXT>') + len('<TEXT>'):rawlist[index].find('</TEXT>')]
            rawdoc = Nrawtext.split(' ')
            rawdocprocessed = rawdoc
            for zz in range(0,len(rawdocprocessed)):
                rawdocprocessed[zz]=process(rawdocprocessed[zz]).strip()
            Nrawtitle = rawlist[index][rawlist[index].find('<TITLE>') + len('<TITLE>'):rawlist[index].find('</TITLE>')]
            print(Nrawtitle)
            for word in newquery:
                if word in Nrawtext.lower():
                    element = rawdocprocessed.index(word)
                    interval = [element, element]
                    break
            for word in newquery:
                if word in Nrawtext.lower():
                    element = rawdocprocessed.index(word)
                    if element < interval[0]:
                        interval = [element, interval[1]]
                    elif element > interval[1]:
                        interval = [interval[0], element]
            start = 0
            end = len(rawdoc)

            if (interval[1] + 10 < end):
                end = interval[1] + 10
            if (interval[0] - 10 > start):
                start = interval[0] - 10
            Nrawtext = rawdoc[start:end]
            parsed = ''
            for e in Nrawtext:
                parsed = parsed + str(e) + ' '
            print('...' + parsed + '...\n\n')

def applyQuery(args,postingList):
    operator='AND'
    sign='YES'
    buffer=[value for key,value in postingList.items()]
    aux2 = []
    for i in buffer:
        aux2+= i
    buffer=list(set([tuple(t) for t in aux2 ]))
    auxbuffer=buffer
    for ind in range(0,len(buffer)):
        buffer[ind]=list(buffer[ind])
    for arg in args:
        if arg=='AND' or arg=='OR':
            operator = arg
        elif arg=='NOT':
            if sign=='YES':
                sign='NOT'
            else:
                sign='YES'
        else:
            buffer=applyOperator(buffer,relevantNews(arg,postingList),operator,sign,postingList,auxbuffer)
            #print('applying op'+' '+operator+' with sign: '+sign+' with argv: '+arg+' buffer count: '+str(len(buffer)))
            operator='AND'
            sign='YES'
    return buffer



def main():
    postingList=load_object(sys.argv[1])
    o=1
    while(o==1):
        print("Welcome to the best fucking query manager bro")
        query=input("Type your query or : ").split()
        if len(query)==0:
            break;
        print("Resultado")
        print(len(applyQuery(query, postingList)))
        #showResult(applyQuery(query, postingList),query)








main()