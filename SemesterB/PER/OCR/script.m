#!/usr/bin/octave -qf
warning off;
if (nargin!=8&&nargin!=11)
	printf("Usage: script.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk> <pca(1),lda(2),pca+lda(3)>\n");
	exit(1);
end

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2} ;
tedata=arg_list{3};
telabs=arg_list{4};
mink=str2num(arg_list{5});
stepk=str2num(arg_list{6});
maxk=str2num(arg_list{7});
mode=str2num(arg_list{8});

if(mode == 3)
	mink2=str2num(arg_list{9});
	stepk2=str2num(arg_list{10});
	maxk2=str2num(arg_list{11});

	valuek2 = [mink2];
	k2 = mink2;
	while(k2<maxk2)
		k2=k2+stepk2;
		valuek2 = [valuek2 k2];
	endwhile
endif

load(trdata);
load(trlabs);
load(tedata) ;
load(telabs);

valuek = [mink];
k = mink;
while(k<maxk)
	k=k+stepk;
	valuek = [valuek k];
endwhile



if(mode == 1 )
	%disp(valuek);
	[m,W]=pca(X);
	%disp(m);
	%disp(W);
	resultp = [];
	for k = valuek
		XR = W(:,1:k)'*(X-m);
		YR = W(:,1:k)'*(Y-m);
		err = knn(XR,xl,YR,yl,1);
		resultp = [resultp ; k err] ;
		disp([k err]);
	endfor
	%disp(resultp);
end

if(mode == 2)
	resultl= [];
	[WL]=lda(X,xl);
	for c = valuek
		XR = WL(:,1:c)'*X;
		YR = WL(:,1:c)'*Y ;
		err = knn(XR,xl,YR,yl,1);
		resultl = [resultl ; c err];
		disp([c err]);	
	endfor
	%disp(resultl);
end

if(mode == 3)
	[m,W]=pca(X);	
	for k = valuek
		XR = W(:,1:k)'*(X-m) ;
		YR = W(:,1:k)'*(Y-m);
		resultl= [];
		[WL]=lda(XR,xl);
		for c = valuek2
			XXR = WL(:,1:c)'*XR;
			YYR = WL(:,1:c)'*YR;
			err = knn(XXR,xl,YYR,yl,1);
			resultl = [resultl ; k c err];
			disp([k c err]);	
		endfor
		%disp(resultl);
	endfor
endif





