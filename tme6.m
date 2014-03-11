%tme6.m
clear all;
close all;
NBK = 10;

[xapp,yapp,xtest,ytest,xtest1,xtest2]=dataset("Checkers",1000,0,0.3);
pal = jet(NBK);
[centers, ypred] = kmeans(xapp,NBK, 10000);

for i=1:NBK
	plot(xapp((ypred==i),1),xapp((ypred==i),2),"+","color",pal(i,:));
	hold on;
end

load("usps_napp10.dat");

 index = 1;
figure
for i=[1:9];
	img = xapp((yapp==i),:);
	ch = rot90(reshape(img(1,:),16,16)); % remise en carre de l'image
	subplot(3,3,index); % division de la fenêtre en 2 pour affichage ultérieur
	hold on;
	imagesc(ch); % affichage
	colormap('gray'); % detail esthétique
	index = index +1;
end

[centers, ypred] = kmeans(xapp,NBK, 1000);
figure;
hist(ypred);