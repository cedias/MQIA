clear all;
close all;
%TME4
source('tme4_fournis.m');
load("PMCs/USPS/pmc_USPS_30_0.01");
[xapp,yapp,xtest,ytest] = dataset('Clowns',100,100,0.01);
load("usps_napp10.dat");



function [ypred] = classPredPMC(data,pmc)
	ypred = [];

for i=1 : size(data,1)
	pmc = put(pmc,data(i,:)');
	pred = propage_avant(pmc);
	[o, Im] = max(pred);
	ypred = [ypred; Im];
end

endfunction
%{
plot(xapp(yapp==1,1),xapp(yapp==1,2),"r+");
	hold on;

plot(xapp(yapp==-1,1),xapp(yapp==-1,2),"b+");


%}
ypred1 = classPredPMC(xapp,pmc);
ypred1(ypred1==yapp) = 0;
ypred1(ypred1!=0) = 1;
nbBadClassifApp = sum(ypred1)


%yapp(yapp==-1)=2;

ypred2 = classPredPMC(xtest,pmc);
ypred2(ypred2==ytest) = 0;
ypred2(ypred2!=0) = 1;
nbBadClassifTest = sum(ypred2)


