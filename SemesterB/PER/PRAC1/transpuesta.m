#!/usr/bin/octave -qf

if(nargin!=1)
	printf("Usage: script.m <matriz.dat>\n");
	exit(1);
end

arglist = argv();
file = arglist{1};
load (file);
sol = A';
save "data_trans.dat" sol;
