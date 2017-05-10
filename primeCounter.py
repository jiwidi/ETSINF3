from primesieve import *
import sys

init=int(sys.argv[1])
end=int(sys.argv[2])

list=primes(init,end)

thefile = open('primes.txt', 'w')
for item in list:
  thefile.write("%s\n" % item)
thefile.close()