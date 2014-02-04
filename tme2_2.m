clear all;
close all;
clf;
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
	NBPOINTS = 50;
	THETA = 0.4;
%-----------------------------------------------------------

%-- Recuperation des Données
	[xapp,yapp,xtest,ytest] = dataset('Gaussian',NBPOINTS,NBPOINTS,0.4);
	xappGa = phiGauss(xapp,{THETA,xapp});
	xtestGa = phiGauss(xtest,{THETA,xapp});

%-- Calcul des Erreurs
%	res = [];
%	for i=1:5
%		res = [res erreurCarre(yapp,knn2(xappGa,yapp,ytest,xtestGa,i))];
%	end

%{ Tracage des courbes de performances
%	subplot(2,1,1);
%	plot(res,[1:NBPOINTS]);
%	hold on;
%}

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
	xgridGa = phiGauss(xgrid,{THETA,xgrid});
	xappGa = phiGauss(xapp,{THETA,xgrid});

	ygrid = knn2(xappGa,yapp,ytest,xgridGa,indexMin);
	plotFrontiere(xgrid,ygrid);
	hold on;
	ygrid = knn2(xappGa,yapp,ytest,xgridGa,indexMax);
	plotFrontiere(xgrid,ygrid);
