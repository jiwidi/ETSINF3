import sys

def main():
    parameters=sys.argv
    print(parameters[1])
    if( parameters[1] == '-f' ):
        print("h")
        signos=(",", ",", ";", "?", "!")
        vocales=("a","e","i","o","u","y")
        infile=open(parameters[2],'r')
        texto=infile.read()
        Output=parameters[0].replace(".py","piglatin.py")
        listafrases=texto.split("\n")
        print(listafrases[0])
        for frase in listafrases:
            palabras=frase.split()
            for palabra in palabras:
                if(palabra[0].isupper() and not (palabra[0].islower()) ):
                    if(palabra[0] in vocales):
                        if(palabra[len(palabra)-1] in signos):
                            output=palabra[:len(palabra)-1]+"yay"+palabra[len(palabra)-1]
                        else:
                            output=palabra+"yay"
                    else:
                        cont=-1
                        for letra in palabra:
                            cont+=1
                            if(letra in vocales):
                                break
                        if(palabra[len(palabra)-1] in signos):
                            output=palabra[cont:len(palabra)-1]+palabra[:cont]+"ay"+palabra[len(palabra)-1]
                        else:
                            output=palabra[cont:]+palabra[:cont]+"ay"

                elif( palabra.isupper()):
                    if(palabra[0] in vocales):
                        if(palabra[len(palabra)-1] in signos):
                            output=palabra[:len(palabra)-1]+"YAY"+palabra[len(palabra)-1]
                        else:
                            output=palabra+"YAY"
                    else:
                        cont=-1
                        for letra in palabra:
                            cont+=1
                            if(letra in vocales):
                                break
                        if(palabra[len(palabra)-1] in signos):
                            output=palabra[cont:len(palabra)-1]+palabra[:cont]+"AY"+palabra[len(palabra)-1]
                        else:
                            output=palabra[cont:]+palabra[:cont]+"AY"
                else:
                    if(palabra[0] in vocales):
                        if(palabra[len(palabra)-1] in signos):
                            output=palabra[:len(palabra)-1]+"yay"+palabra[len(palabra)-1]
                        else:
                            output=palabra+"yay"
                    else:
                        cont=-1
                        for letra in palabra:
                            cont+=1
                            if(letra in vocales):
                                break
                        if(palabra[len(palabra)-1] in signos):
                            output=palabra[cont:len(palabra)-1]+palabra[:cont]+"ay"+palabra[len(palabra)-1]
                        else:
                            output=palabra[cont:]+palabra[:cont]+"ay"
                #aqui escribo la palabra en el output
            #aqui escribo \n en el output

main()
