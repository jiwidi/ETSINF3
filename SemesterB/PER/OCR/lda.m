%#!/usr/bin/octave -qf

%if(nargin!=2)
%	printf("Usage: script.m <matriz.mat.gz> <etiquetas.mat.gz>\n");
%	exit(1);
%end

%arglist = argv();
%file = arglist{1};
%load (file);
%file = arglist{2};
%load (file);


function [W]=lda(X,xl)
	k=size(X);
	columns = k(2);
	rows = k(1);
	mx = 0;
	for i = 1:columns
		curr=X(:,i);
		mx = mx + curr;
	endfor
	mx = mx/columns;	
	Sw = zeros (rows,rows);
	Sb = zeros (rows,rows);
	for c = unique(xl)
		indc = find(xl==c);
		xc = X(:,indc);
		mc = 0;
		sc = size(xc);
		nc = sc(2);
%		disp(nc);
		for i = 1:nc
			curr=xc(:,i);
			mc = mc + curr;
		endfor
		mc = mc/nc;
		A=xc;
		k=1;
		for i = indc
			A(:,k++)= X(:,i)-mc;
		endfor
		Ec=(A*A')/nc;
		Sw = Sw + Ec;
		mb = nc*(mc-mx)*(mc-mx)';
		Sb = Sb + mb;
	endfor
	[V,lambda]=eig(Sb,Sw);
	[L,I]=sort(-diag(lambda));
	W=V(:,I);
%	disp(size(W));
	sxl = size(unique(xl));
	dc = sxl(2);
	W = W(:,1:dc-1);
endfunction


%[ww]=lda(X,xl);
%	for i = 1:5
%		hh=ww(:,i);
%		xr=reshape(hh,16,16);
% 		imshow(xr',[min(min(xr)),max(max(xr))]);
%		ans = input("next image\n");
%	endfor
