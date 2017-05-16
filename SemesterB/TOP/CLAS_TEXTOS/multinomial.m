#!/usr/bin/octave -qf

if(nargin!=1)printf("Usage: multinomial.m <data_filename>");
	exit(1);
end
arglist=argv();
datafile=arglist{1};
disp("Loading data...");
load(datafile);
disp("Data load complete.")

[nrows,ncols]=size(data);
rand("seed",23);
perm=randperm(nrows);
pdata=data(perm,:);

trper=0.9;
ntr=floor(nrows*trper);
nte=nrows-ntr;
tr=pdata(1:ntr,:);
te=pdata(ntr+1:nrows,:);

[trrows,trcols]=size(tr);

hamv = find(tr(:,trcols)==0);
%disp(hamv);
[totalham,xd]=size(hamv);
disp(totalham);
matrixtr = tr(:,1:end-1);
labelstr = tr(:,end);
matrixham = tr(hamv,1:end-1);
sham = sum(matrixham);
slow = sum(sham);
wcham = log((1/(slow))*sham);
bcham = log(totalham/trrows);

spamv = find(tr(:,trcols)==1);
%disp(spamv);
[totalspam,xd]=size(spamv);
disp(totalspam)
matrixspam = tr(spamv,1:end-1);
sspam = sum(matrixspam);
spamlow = sum(sspam);
wcspam = log((1/(spamlow))*sspam);
bcspam = log(totalspam/trrows);

ghtr = wcham*matrixtr' + bcham;
gstr = wcspam*matrixtr' + bcspam;

resulttr = ghtr<gstr;
trresult=ne(resulttr', labelstr);

[trerrors,xd]=size(find(trresult(:,:)=1));
disp(trerrors/trcols);


matrixte = te(:,1:end-1);
labelste = te(:,end);
[terows,tecols]=size(te);

ghte = wcham*matrixte' + bcham;
gste = wcspam*matrixte' + bcspam;

resultte = ghte<gste;
teresult=resultte!=labelste';

[teerrors,xd]=size(find(teresult(:,:)=1));
disp(teresult);




