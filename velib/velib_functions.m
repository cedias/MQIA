%velib_functions

%affiche l'activité generale
function [] = plotActiviteGenerale(velib_take, velib_let)
figure
plot(sum(velib_take + velib_let,1));
end

%affiche les stations de paris /!\ stations 0 0 /!\
function [] = plotStationsParis(infostations)
coord = infostations(:,[2,3]);
ind = find(coord(:,1)==0);
ind2 = find(coord(:,2)==0);
coord(ind,1) = 2.33;
coord(ind2,2) = 48.8;
plot(coord(:,1),coord(:,2),"r+");
end

%nombre max velib par stations
function [maxV] = maxVeloStations(velib_curr)
	maxV = max(velib_curr,[],2);
end

%activité d'une station
function [activ] = activiteStation(velib_take, velib_let, index)
	activ = velib_take(index,:) + velib_let(index,:);
end

%normalise par nombre veloMax
function[velib_take_N,velib_let_N,velib_curr_N] = normMax(velib_take,velib_let,velib_curr)
maxV = maxVeloStations(velib_curr);
divs = repmat(maxV,1,1008);
velib_curr_N = velib_curr./divs;
velib_take_N = velib_take./divs;
velib_let_N = velib_let./divs;
velib_curr_N(isnan(velib_curr_N)) = 0;
velib_take_N(isnan(velib_take_N)) = 0;
velib_let_N(isnan(velib_let_N)) = 0;
end

%compacte les données => change la fenetre
function [velib_take_c,velib_let_c,velib_curr_c] = compact(velib_take,velib_let,velib_curr,taillePaquets)
	velib_take_c = [];
	velib_let_c = [];
	velib_curr_c = [];
	for i=[1:taillePaquets:size(velib_curr,2)]
		velib_take_c = [ sum(velib_take %%%%%%%%%%%%%%%TODO
	end
	
	
end
