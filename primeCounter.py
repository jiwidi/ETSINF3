import threading
import math
import time

try:
    a = open('prime0_10000000000.txt', 'r')
    #f.write('2\n')
    aux=a.readlines()
    startvalue=int(aux[len(aux)-1])+2
    a.close()
    f = open('prime0_10000000000.txt', 'a')
except:
    startvalue=3
    f = open('prime0_10000000000.txt', 'a')
    f.write('%d\n' % 1)
    f.write('%d\n' % 2)

def getprimos(a,b):
    xx=startvalue+a
    ende=startvalue+b
    while xx <= ende:
        k = math.ceil(math.sqrt( xx ))
        y=3
        flag = True
        while y <= k:
            if xx%y == 0:
                flag = False
                break
            y += 2
        if flag:
            f.write('%d\n' % xx)

        xx+=2
    #f.close()
    #return result
jobs = []
x=10000000000 # times to execute loop
threads = 8
start = time.time()
for i in range(1, threads+1):
    out_list = list()
    ini=(x/threads)*(i-1)
    end=(x/threads)*i
    thread = threading.Thread(target=getprimos(ini , end) )
    jobs.append(thread)

# Start the threads (i.e. calculate the random number lists)
for j in jobs:
	j.start()

# Ensure all of the threads have finished
for j in jobs:
	j.join()
end = time.time()
print (end - start)
