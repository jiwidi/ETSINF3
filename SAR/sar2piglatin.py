import sys

def main():
    parameters=sys.argv
    if(len(sys.argv)>1):
        if( parameters[1] == '-f' ):
            piglatin_sentence(parameters[2])
        else:
            print(piglatin_sentence(sys.argv[1]))
    else:
        o = 1
        while (o == 1):
            print("Wrong input, type again please \n")
            aux = input()
            listaux=aux.split()

            if (listaux[0]==''):
                print("Wrong input, type again please \n")

            elif(listaux[0]=='-f'):
                piglatin_file(listaux[1])
                o = 2
            else:
                print(piglatin_sentence(aux))
                o=2
def piglatin_file(name):
            infile=open(name,'r')
            texto=infile.read()
            Output=name.replace(".txt","_piglatin.txt")
            f=open(Output,'w')
            listafrases=texto.split("\n")
            print(listafrases[0])
            for frase in listafrases:
                out=piglatin_sentence(frase)
                f.write(out+'\n')
def piglatin_sentence(frase):
    signos = (",", ",", ";", "?", "!")
    vocales = ("a", "e", "i", "o", "u", "y")
    palabras=frase.split()
    resultado=''
    for palabra in palabras:
        output = palabra
        if (palabra[0].isalpha()):
            yay = "yay"
            ay = "ay"
            if (palabra.isupper()):
                yay = "YAY"
                ay = "AY"

            if (palabra[0].lower() in vocales):
                if (palabra[0].isupper()):
                    if (palabra[len(palabra) - 1] in signos):
                        output = palabra[:len(palabra) - 1] + yay + palabra[len(palabra) - 1]
                    else:
                        output = palabra + yay
                else:
                    if (palabra[len(palabra) - 1] in signos):
                        output = palabra[:len(palabra) - 1] + yay + palabra[len(palabra) - 1]
                    else:
                        output = palabra + yay

            else:
                ind = -1
                for letra in palabra:
                    ind += 1
                    if (letra in vocales):
                        break
                if (palabra[0].isupper()):
                    if (palabra[len(palabra) - 1] in signos):
                        output = palabra[ind].upper() + palabra[ind + 1:len(palabra) - 1] + palabra[
                            0].lower() + palabra[1:ind] + ay + palabra[len(palabra) - 1]
                    else:
                        output = palabra[ind].upper() + palabra[ind + 1:] + palabra[0].lower() + palabra[1:ind] + ay
                else:
                    if (palabra[len(palabra) - 1] in signos):
                        output = +palabra[ind:len(palabra) - 1] + palabra[0].lower() + palabra[1:ind] + ay + palabra[
                            len(palabra) - 1]
                    else:
                        output = palabra[ind:] + palabra[:ind] + ay
        resultado+=output+' '
    return resultado


main()
