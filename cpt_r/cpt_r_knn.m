%Compte_rendu: KNN
clear all;
close all;

function [tx_err] = tx_err(Y,Ypred)

	res = zeros(size(Y,1),1);
	res((Y~=Ypred))=1;
	tx_err = (sum(res)/size(res,1))*100;

endfunction

function [] = plotAndSaveBest(X,Y,res,filename)

	figure;
	subplot(1,2,1);
	bar(res);

	subplot(1,2,2);
	plot(X((Y==1),1),X((Y==1),2),"r*");
	hold on;
	plot(X((Y==-1),1),X((Y==-1),2),"b+");
	hold on;
	[val, nb] = min(res);
	nbErreurKNNPerc = val
	xgrid = generateGrid(X,50);
	ygrid = knn2(X,Y,Y,xgrid,nb);
	plotFrontiere(xgrid,ygrid);
	saveas(1,filename, "epsc");

endfunction


function [tx_Val] = protocoleTestKNN(X,Y,nbCrossVal,maxN)
	tx_Val = [];
	tx_CV = [];

	for i=1 : maxN %nb of neighbors

		for cv = 1: nbCrossVal %nb of partition

			[xval, yval, xapp, yapp] = crossval(X, Y, nbCrossVal, cv);
			yres = knn2(xapp,yapp,unique(yapp),xval,i);
			tx_CV = [tx_CV tx_err(yval,yres)];

		end
		tx_Val = [tx_Val mean(tx_CV)];
		tx_CV = [];
	end

endfunction

%%%%%%%%%%%%%%%%% -- START -- %%%%%%%%%%%%%%%%%%%%%%%%

load("usps_napp10.dat");
xappUS = [xapp;xtest];
yappUS = [yapp;ytest];

perm = randperm(size(xappUS,1));
xappUS = xappUS(perm,:);
yappUS = yappUS(perm,:);

%Gaussian:
[xappGA,yappGA,os,ef] = dataset('Gaussian',200,0,0.4);

%Clowns:
[xappCL,yappCL,os,ef] = dataset('Clowns',200,0,0.4);

%Checkers:
[xappCh,yappCh,os,ef] = dataset('Checkers',200,0,0.4);


res = protocoleTestKNN(xappGA,yappGA,4,49);
plotAndSaveBest(xappGA,yappGA,res,"gaknn.eps");

res = protocoleTestKNN(xappCL,yappCL,4,49);
plotAndSaveBest(xappCL,yappCL,res,"cloknn.eps");

res = protocoleTestKNN(xappCh,yappCh,4,48);
plotAndSaveBest(xappCh,yappCh,res,"cheknn.eps");


res = protocoleTestKNN(xappUS([1:400],:),yappUS([1:400],:),4,24);
[val, nb] = min(res);
%knn2(xappUS,yappUS,yappUS,xgrid,nb);
%}

