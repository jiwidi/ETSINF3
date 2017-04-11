%#!/usr/bin/octave -qf

%if(nargin!=1)
%	printf("Usage: script.m <matriz.dat>\n");
%	exit(1);
%end

%arglist = argv();
%file = arglist{1};
%load (file);


function [m,W]=pca(X)
	k=size(X);
	columns = k(2);
	rows = k(1);
	m = 0;
	for i = 1:columns
		curr=X(:,i);
		m = m + curr;
	endfor
	m = m/columns;	
%	disp(m);
	A=X;
	for i = 1:columns
		A(:,i)= X(:,i)-m;
	endfor
	cov=(A*A')/columns;
	[V,lambda]=eig(cov);
	[L,I]=sort(-diag(lambda));
	W=V(:,I);
endfunction


%[mm,ww]=pca(X);
%	for i = 1:5
%		hh=ww(:,i);
%		xr=reshape(hh,16,16);
% 		imshow(xr',[min(min(xr)),max(max(xr))]);
%		ans = input("next image\n");
%	endfor
