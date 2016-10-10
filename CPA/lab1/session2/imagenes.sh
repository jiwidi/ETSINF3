#!/bin/bash
#PBS -l nodes=1,walltime=00:05:00
#PBS -q cpa
#PBS -d .

OMP_NUM_THREADS=32 ./imagenes
OMP_NUM_THREADS=32 ./loopI
OMP_NUM_THREADS=32 ./loopJ
OMP_NUM_THREADS=32 ./loopK
OMP_NUM_THREADS=32 ./loopL
