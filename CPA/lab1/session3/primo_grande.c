#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <omp.h>

typedef unsigned long long Entero_grande;
#define ENTERO_MAS_GRANDE  ULLONG_MAX
double t1,t2;
int primo(Entero_grande n)
{
  int p;
  Entero_grande i, s;
  p = (n % 2 != 0 || n == 2);

  if (p) {
    s = sqrt(n);
	
	#pragma omp parallel private(i)
	{
		int numberOfThreads = omp_get_num_threads();
		int id=omp_get_thread_num();

    	for (i = id*2+3; p && i <= s; i += numberOfThreads)
      		if (n % i == 0) p = 0;
  		}
	}
	
	printf("none\t%f\t%d\n", t2-t1, omp_get_num_threads());
  return p;
}

int main()
{
  	Entero_grande n;
	
	t1 =omp_get_wtime();
  	for (n = ENTERO_MAS_GRANDE; !primo(n); n -= 2) {
    /* NADA */
  	}
	t2=omp_get_wtime();
	printf("none\t%f\t%d\n", t2-t1, omp_get_num_threads());
  	printf("El mayor primo que cabe en %d bytes es %llu.\n",
         sizeof(Entero_grande), n);

  return 0;
}
