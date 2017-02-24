import sys

def main():
    parameters=sys.argv
    print(parameters[1])
    if( parameters[1] == '-f' ):
        print("h")
        infile=open(parameters[2],'r')
        texto=infile.read()
        Output=parameters[0].replace(".py","piglatin.py")
        listapalabras=texto.split()
        print(listapalabras[1])
        





main()