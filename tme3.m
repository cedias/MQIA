
clear all;
close all;
% TME2
source('tme3_fonctions.m');
%source('tme3_fonctions2.m');

[xapp,yapp,xtest,ytest] = dataset('Gaussian',100,100,0.55);

plot(xapp(yapp==1,1),xapp(yapp==1,2),"r+");
	hold on;

plot(xapp(yapp==-1,1),xapp(yapp==-1,2),"b+");

Base={xapp;yapp};
w = init_params(Base);
[histW1, histC1] = optimise_gradient_batch(Base, 0.01, 1, w , @cout_mse, @dcout_mse );
[histW2, histC2] = optimise_gradient_stoch(Base, 0.01, 1, w , @cout_mse, @dcout_mse );

histW1 = histW1';
histW2 = histW2';

figure
plot(histW1(:,1),histW1(:,2),"b+");
hold on;
plot(histW2(:,1),histW2(:,2),"g+");

figure
plot(histC1);
figure
plot(histC2);





%plot(histW1);

