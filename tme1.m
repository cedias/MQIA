clear all;
close all;


function [mat] = lineDup(a,nb)
	tailleA=size(a,1);
	largA=size(a,2);
	mat = reshape(repmat(a,1,nb)',largA,tailleA*nb)';
endfunction

function [Ypred] = knn(X,Y,k,Xtest)

dist = (repmat(X,size(Xtest,1),1)-lineDup(Xtest,size(X,1))).^2
dist = reshape(sum(dist,2),size(X,2),size(Xtest,2));

if k==1 then
	[a,points] = min(dist);
	Ypred = Y(points);
else
	[a,points] = sort(dist);
	Ypred=max(hist(points,Y));
end;

endfunction


%load("usps_napp10.dat");
[xapp,yapp,xtest,ytest] = dataset('Clowns',30,30,0.5);


res = knn2(xapp,yapp,ytest,xtest,4);
list = find(yapp==-1);
list2 = find(yapp == 1);

plot(xapp(list,1),xapp(list,2),"r+");
hold on;
plot(xapp(list2,1),xapp(list2,2),"b+");
hold on;

xgrid = generateGrid(xapp,50);
ygrid = knn2(xapp,yapp,ytest,xgrid,9);
plotFrontiere(xgrid,ygrid);

