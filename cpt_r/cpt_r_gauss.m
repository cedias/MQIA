%Compte_rendu: Perceptron/Adaline
clear all;
close all;
source('tme3_fonctions.m');

%%%%%%%%%%%%%%%%%% -- Functions -- %%%%%%%%%%%%%%%%%%
function [] = testAndSaveEps(Base)
test =[1,0.1,0.01,0.001];
w = init_params(Base);
histW = [];
for i=1:size(test,2)
	[histW2, histC2] = optimise_gradient_stoch(Base,test(i), 1, w ,2, @cout_mse, @dcout_mse );
	histW2 = histW2';
	histW = [histW histW2];
end

figure
subplot(2,2,1)
hold on;
title ("Epsilon = 1");
plot(histW(:,1),histW(:,2),"g+");
subplot(2,2,2)
hold on;
title ("Epsilon = 0.1");
plot(histW(:,3),histW(:,4),"r+");
subplot(2,2,3)
hold on;
title ('Epsilon = 0.01');
plot(histW(:,5),histW(:,6),"b+");
subplot(2,2,4)
hold on;
title ('Epsilon = 0.001');
plot(histW(:,7),histW(:,8),"y+");

saveas(1,"epsilons.eps", "epsc");
endfunction

function [] = testAndSaveIter(Base)

w = init_params(Base);

figure
[histW, histC] = optimise_gradient_stoch(Base,0.01, 1, w ,2, @cout_mse, @dcout_mse );
plot(histC,"b+");
saveas(1,"iter.eps", "epsc");
endfunction


function [tx_err, tx_pc] = tauxErreurW(xapp,yapp,w)
	ypredVal = xapp*w';
	ypred = sign(ypredVal);
	tx_pc = (sum(abs(ypred .- yapp)./2)/size(yapp,1))*100 ;
	tx_err = mean((ypredVal - yapp) .^2);
	
endfunction


function [] = plotAndSaveResults(txA,tcA,txV,tcV,w,X,Y)
figure;
subplot(2,2,1);
bar(txA,"r");
subplot(2,2,2);
bar(tcA);
subplot(2,2,3);
bar(txV,"r");
subplot(2,2,4);
bar(tcV);
saveas(1,"erreurGauss.eps", "epsc");
figure
plot(X((Y==1),1),X((Y==1),2),"r*");
hold on;
plot(X((Y==-1),1),X((Y==-1),2),"b+");

xgrid = generateGrid(X,100);
ygrid = xgrid*w;
plotFrontiere(xgrid,ygrid);
saveas(2,"frontiereGauss.eps", "epsc");
endfunction
%%%%%%%%%%%%%%%%% -- START -- %%%%%%%%%%%%%%%%%%%%%%%%
%PARAMS
iter = 5; %nb apprentissage base
cv = 1; % nb division données

%Gaussian:
[xappGA,yappGA,os,ef] = dataset('Gaussian',1000,0,0.4);
Base={xappGA;yappGA};
%testAndSaveEps(Base); %test epsilon's and save .eps
%testAndSaveIter(Base); %test iter' and save .eps

tcA=[]; %pourcentage erreur app
tcV=[]; %pourcentage erreur test
txA=[]; %erreur mc app
txV=[]; %erreur mc test
for i=1:4
	[xval, yval, xapp, yapp] = crossval(xappGA, yappGA, 4, i);
	Base = {xapp,yapp};
	w = init_params(Base);
	[histW, histC] = optimise_gradient_stoch(Base,0.01, 1, w ,5, @cout_mse, @dcout_mse );
	wt = histW';
	r = wt(length(wt),:);
	[_txA, _tcA] = tauxErreurW(xapp,yapp,r);
	[_txV, _tcV] = tauxErreurW(xval,yval,r);

	tcA =[tcA _tcA];
	txA =[txA _txA];
	tcV =[tcV _tcV];
	txV =[txV _txV];
end

%plotAndSaveResults(txA,tcA,txV,tcV,w,xappGA,yappGA);
tx_pourcentage_test = mean(tcV)
tx_pourcentage_apprentissage = mean(tcA)
tx_mc_apprentissage = mean(txA)
tx_mc_test = mean(txV)

%%%%%%%%%% - USPS - %%%%%%%%%%ù

load("usps_napp10.dat");

perm = randperm(size(xapp,1));
xapp = xapp(perm,:);
yapp = yapp(perm,:);

modeles = [];
for i=1:10 %on va creer 9 modèles
	baseY = yapp;
	baseY(yapp == i)=1;
	baseY(yapp ~= i)=-1;
	Base={xapp,baseY};
	w = init_params(Base);
	[histW, histC] = optimise_gradient_stoch(Base,0.001, 1, w ,50, @cout_mse, @dcout_mse );
	modeles = [modeles  histW(:,size(histW,2))];
end

plot(histC([1000:length(histC)]))

%modeles - 9 colonnes - 256 lignes
%xapp - 100 l - 256 col
res = [];
for i=1:10
	res = [res xapp*modeles(:,i)];
end

[a,labels] = max(res,[],2);



figure
for(i=1:10)
	subplot(3,4,i);
	imagesc(reshape(modeles(:,i),16,16)')
end

