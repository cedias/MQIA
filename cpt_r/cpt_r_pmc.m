clear all;
close all;
source('tme5_fournis.m');
%TME5

function [sortie] = labelToVector(label,nbLabel)
	sortie = zeros(nbLabel,1);
	sortie(label)=1;
endfunction

function [label] = vectorTolabel(vector)
	[osef, label] = max(vector);
endfunction

function [erreurMC,erreurPC,pmc] = train_pmc(x,y,in,out,hidd,epsi,iter)
pmc = init_pmc(in,out,hidd);
erreurMC = [];
erreurPC = [];
for i=1:iter
	perm = randperm(size(x,1));
	dataX = x(perm,:);
	dataY = y(perm,:);
	erreurIT = [];
	erreurPCIT = [];
	

	for j=1:size(x,1)
		pmc = put(pmc,dataX(j,:)');
		[sortie, pmc] = propage_avant(pmc);


		label_sortie = vectorTolabel(sortie);
		if(label_sortie != dataY(j))
			erreurPCIT = [erreurPCIT 1];
		end
		await = labelToVector(dataY(j), size(unique(y),1));
		erreurIT = [erreurIT sum((sortie - await).*(sortie-await))];


		pmc = retro_propage(pmc,sortie - await ,epsi);
	end
	 erreurMC = [erreurMC mean(erreurIT)];
	 erreurPC = [erreurPC ((sum(erreurPCIT)/size(x,1))*100)];

end

endfunction

function [erreurMC,pmc] = train_pmc_bin(x,y,in,out,hidd,epsi,iter)
pmc = init_pmc(in,out,hidd);
erreurMC = [];
erreurPC = [];
for i=1:iter
	perm = randperm(size(x,1));
	dataX = x(perm,:);
	dataY = y(perm,:);
	erreurIT = [];
	

	for j=1:size(x,1)
		pmc = put(pmc,dataX(j,:)');
		[sortie, pmc] = propage_avant(pmc);
		err = sortie - dataY(j,:);
		pmc = retro_propage(pmc,err ,epsi);
		erreurIT= [erreurIT sum(err.*err)];
	end
	 erreurMC = [erreurMC mean(erreurIT)];

end

endfunction

function [ypred] = classPredPMC(data,pmc)
	ypred = [];

for i=1 : size(data,1)
	pmc = put(pmc,data(i,:)');
	pred = propage_avant(pmc);
	[o, Im] = max(pred);
	ypred = [ypred; Im];
end

endfunction

function [ypred] = classPredPMC_bin(data,pmc)
	ypred = [];

for i=1 : size(data,1)
	pmc = put(pmc,data(i,:)');
	ypred = [ypred propage_avant(pmc)];
end

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INPUT = 2; %nb_pixels
OUTPUT = 1; %nb_classes
HIDDEN = {10}; %nb couches cachés
EPS = 0.01;
ITERATION = 100;
NBCROSSVAL = 4;
USPSONLY = 1;
%%%%%%%%%%%%%%%%%%%%%%%- START -%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Checkers:
[xappCh,yappCh,os,ef] = dataset('Checkers',1000,0,0.4);



if USPSONLY ~= 1

errPC = [];
cv=1;
for cv = 1: NBCROSSVAL %nb of partition
		[xval, yval, xapp, yapp] = crossval(xappCh, yappCh, NBCROSSVAL, cv);
		[erreurMC, pmc] = train_pmc_bin(xapp,yapp,INPUT,OUTPUT,HIDDEN,EPS,ITERATION);
		pred = classPredPMC_bin(xval,pmc)';
		res = sign(pred);
		res(yval == res) = 0;
		res(res ~= 0) = 1;
		errPC = [errPC (sum(res)/size(yval,1))*100];
end

	subplot(2,2,1);
	plot(erreurMC); % erreur MC derniere crossval
	erreurMCCheck = erreurMC(length(erreurMC))
	errPCCheck = mean(errPC)
	subplot(2,2,2);
	plot(xappCh((yappCh==1),1),xappCh((yappCh==1),2),"r*");
	hold on;
	plot(xappCh((yappCh==-1),1),xappCh((yappCh==-1),2),"b+");
	hold on;

	xgrid = generateGrid(xappCh,50);
	ygrid = classPredPMC_bin(xgrid,pmc);
	
	plotFrontiere(xgrid,ygrid);
	

%Clowns:
[xappCh,yappCh,os,ef] = dataset('Clowns',1000,0,0.4);


errPC = [];
cv=1;
for cv = 1: NBCROSSVAL %nb of partition
		[xval, yval, xapp, yapp] = crossval(xappCh, yappCh, NBCROSSVAL, cv);
		[erreurMC, pmc] = train_pmc_bin(xapp,yapp,INPUT,OUTPUT,HIDDEN,EPS,ITERATION);
		pred = classPredPMC_bin(xval,pmc)';
		res = sign(pred);
		res(yval == res) = 0;
		res(res ~= 0) = 1;
		errPC = [errPC (sum(res)/size(yval,1))*100];
end
	subplot(2,2,3);
	plot(erreurMC);
	erreurMCclown = erreurMC(length(erreurMC))
	errPCClown = mean(errPC)
	subplot(2,2,4);
	plot(xappCh((yappCh==1),1),xappCh((yappCh==1),2),"r*");
	hold on;
	plot(xappCh((yappCh==-1),1),xappCh((yappCh==-1),2),"b+");
	hold on;

	xgrid = generateGrid(xappCh,50);
	ygrid = classPredPMC_bin(xgrid,pmc);
	
	plotFrontiere(xgrid,ygrid);
	saveas(1,"frontPMCCh.eps","epsc");

end

%USPS

load("usps_napp10.dat");

pmc = init_pmc(257,10,{15});

[erreurMC, pmc] = train_pmc(xapp,yapp,256,10,HIDDEN,EPS,1);
res = classPredPMC(xtest,pmc);
