function [err]=knn(X,xl,Y,yl,KNN)

[d,n]=size(X);
[dt,nt]=size(Y);


D = pdist2( Y', X', "euclidean");
[D,idx] = sort(D, 2, 'ascend');


%# KNN nearest neighbors
D = D(:,1:KNN);
idx = idx(:,1:KNN);

%# majority vote
prediction = mode(xl'(idx),2);

cerr = (yl'-prediction);

err=nt-sum(cerr(:)==0);
  
err=(err*100.0)/nt;

  
endfunction
