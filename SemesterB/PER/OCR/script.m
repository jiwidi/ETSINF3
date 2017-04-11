#!/usr/bin/octave -qf

if (nargin!=7)
	printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
	exit(1);
end

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
mink=str2num(arg_list{5});
stepk=str2num(arg_list{6});
maxk=str2num(arg_list{7});
load(trdata);
load(trlabs);
load(tedata);
load(telabs);

valuek = [mink];
k = mink;

while(k<maxk)
	k=k+stepk;
	valuek = [valuek k];
endwhile
%disp(valuek);
[m,W]=pca(X);
%disp(m);
%disp(W);
resultp = [];
for k = [1 2 3 4 5 6 7 8 9]
		XR = W(:,1:k)'*(X-m);
		YR = W(:,1:k)'*(Y-m);
		err = knn(XR,xl,YR,yl,1);
		resultp = [resultp ; k err];
endfor
disp(resultp);

%resultl= [];
%[WL]=lda(X,xl);
%for c = unique(xl)
%	XR = WL(:,1:c)'*X;
%	YR = WL(:,1:c)'*Y;
%	err = knn(XR,xl,YR,yl,1);
%	resultl = [resultl ; c err];	
%endfor
%disp(resultl);

