clear all;
close all;
%TME4
source('tme4_fournis.m');
load("PMCs/USPS/pmc_USPS_25_0.01");
%[xapp,yapp,xtest,ytest] = dataset('Clowns',100,100,0.01);
load("usps_napp10.dat");

%{
plot(xapp(yapp==1,1),xapp(yapp==1,2),"r+");
	hold on;

plot(xapp(yapp==-1,1),xapp(yapp==-1,2),"b+");


%}
ypred1 = [];
%yapp(yapp==-1)=2;

for i=1 : size(xapp,1)
	pmc = put(pmc,xapp(i,:)');
	pred = propage_avant(pmc);
	[o, Im] = max(pred);
	ypred1 = [ypred1; Im];
end

nbBadClassifApp = sum(yapp - ypred1) %faux marche que pour 1 & -1

ypred2 = [];
%yapp(yapp==-1)=2;

for i=1 : size(xtest,1)
	pmc = put(pmc,xtest(i,:)');
	pred = propage_avant(pmc);
	[o, Im] = max(pred);
	ypred2 = [ypred2; Im];
end

nbBadClassifTest = sum(ytest - ypred2) %faux marche que pour 1 & -1


