%Compte_rendu: Data
clear all;
close all;

%% functionname: function description
function [] = saveDataPS(name,xapp,yapp)
plot(xapp(yapp==1,1),xapp(yapp==1,2),"r+");
hold on;
plot(xapp(yapp==-1,1),xapp(yapp==-1,2),"b*");


	filename = [name ".eps"];
	saveas(1,filename, "epsc");
end

figure;
%Gaussiennes:
[xapp,yapp,xtest,ytest] = dataset('Gaussian',200,0,0.4);
saveDataPS("Gaussian",xapp,yapp);
clf;
%Clowns:
[xapp,yapp,xtest,ytest] = dataset('Clowns',200,0,0.4);
saveDataPS("Clowns",xapp,yapp);
clf;
%Checkers:
[xapp,yapp,xtest,ytest] = dataset('Checkers',200,0,0.4);
saveDataPS("Checkers",xapp,yapp);
clf;
close all;
clear all;
%USPS:
load("usps_napp10.dat");
index = 1;
figure
for i=[1:10:90];
	ch = rot90(reshape(xapp(i,:),16,16)); % remise en carre de l'image
	subplot(3,3,index); % division de la fenêtre en 2 pour affichage ultérieur
	hold on;
	imagesc(ch); % affichage
	colormap('gray'); % detail esthétique
	index = index +1;
end
saveas(1,"USPS.eps", "epsc");


