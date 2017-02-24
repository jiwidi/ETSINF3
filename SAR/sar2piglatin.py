import sys

def main():
    parameters=sys.argv
    print(parameters[1])
    if( parameters[1] == '-f' ):
        print("h")
        signos=(",", ",", ";", "?", "!");
        infile=open(parameters[2],'r')
        texto=infile.read()
        Output=parameters[0].replace(".py","piglatin.py")
        listafrases=texto.split("\n")
        print(listafrases[0])
        for u in listafrases:
            listapalabras=u.split(signos)
            for i in listapalabras:
                if(not u.startswith()):
                    


        





main()