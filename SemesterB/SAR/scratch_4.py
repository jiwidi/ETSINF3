import sys
import os


def main():
    #direc=sys.argv[1]
    #finalName=sys.argv[2]
    for filename in os.listdir("enero/"):
        print(filename)
        aux=open("enero/"+filename,'r')
        #print(aux.read())
        aux.close()
main()
