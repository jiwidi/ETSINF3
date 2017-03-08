#!/bin/bash
GCC="gcc -lm -fopenmp -Wall"
$GCC -o loopI loopI.c
$GCC -o loopJ loopJ.c
$GCC -o loopK loopK.c
$GCC -o loopL loopL.c
$GCC -o imagenes imagenes.c
