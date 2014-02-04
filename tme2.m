clear all;
close all;
% TME2

% ----------------------------------------------------------
% FUNCTIONS
%-----------------------------------------------------------

	function [erreur] = erreurCarre(expected,truth)
		erreur = sum((expected - truth).* (expected-truth));
	endfunction

	function [erreur] = erreurPourcent(expected, truth)
		erreur = size(find(expected != truth),1)/size(expected,1);
	endfunction



% ----------------------------------------------------------
% CONSTANTES
%-----------------------------------------------------------
	NBPOINTS = 60;
%-----------------------------------------------------------

[xapp,yapp,xtest,ytest] = dataset('Clowns',NBPOINTS,NBPOINTS,0.9);

%-- Calcul des Erreurs
res = [];
for i=1:NBPOINTS
	res = [res erreurCarre(yapp,knn2(xapp,yapp,ytest,xtest,i))];
end

%-- Tracage des courbes de performances
subplot(2,1,1);
plot(res,[1:NBPOINTS]);
hold on;

%-- Tracage des frontières
[osef, indexMin] = min(res);
[osef, indexMax] = max(res);

list = find(yapp==-1);
list2 = find(yapp == 1);

subplot(2,1,2);
plot(xapp(list,1),xapp(list,2),"r+");
hold on;
plot(xapp(list2,1),xapp(list2,2),"b+");
hold on;

xgrid = generateGrid(xapp,NBPOINTS);
ygrid = knn2(xapp,yapp,ytest,xgrid,indexMin);
plotFrontiere(xgrid,ygrid);
hold on;
ygrid = knn2(xapp,yapp,ytest,xgrid,indexMax);
plotFrontiere(xgrid,ygrid);
