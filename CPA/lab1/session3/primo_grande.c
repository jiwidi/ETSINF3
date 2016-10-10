#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <omp.h>
#include <string.h>




typedef unsigned long long Entero_grande;
#define ENTERO_MAS_GRANDE  ULLONG_MAX

int primo(Entero_grande n)
{
  int volatile p,s,i;
  

   p = (n % 2 != 0 || n == 2);

  if (p) {
    s = sqrt(n);

    for (i = 3; p && i <= s; i += 2)
      if (n % i == 0) p = 0;
  }

  return p;
}

int main()
{
	int t1,t2;
  Entero_grande n;
  t1 = omp_get_wtime();
  for (n = ENTERO_MAS_GRANDE; !primo(n); n -= 2) {
    /* NADA */
  }

  printf("El mayor primo que cabe en %d bytes es %llu.\n",
         sizeof(Entero_grande), n);
	t2 = omp_get_wtime();
  printf("none\t%f\t%d\n", t2 - t1, omp_get_num_threads());

  return 0;
}
