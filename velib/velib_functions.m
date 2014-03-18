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
function [velib_take_N,velib_let_N,velib_curr_N] = normMax(velib_take,velib_let,velib_curr)
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

		if(i+taillePaquets<= size(velib_curr,2))
			velib_curr_c = [velib_curr_c sum(velib_curr(:,[i:i+taillePaquets]),2)];
			velib_take_c = [velib_take_c sum(velib_take(:,[i:i+taillePaquets]),2)];
			velib_let_c = [velib_let_c sum(velib_let(:,[i:i+taillePaquets]),2)];
		else
			velib_curr_c = [velib_curr_c sum(velib_curr(:,[i:size(velib_curr,2)]),2)]; % truncate data ?
			velib_take_c = [velib_take_c sum(velib_take(:,[i:size(velib_take,2)]),2)]; % truncate data ?
			velib_let_c = [velib_let_c sum(velib_let(:,[i:size(velib_let,2)]),2)]; % truncate data ?
		end
		
	end
	
	
end

%données compacté jours par jours
function [velib_take_day,velib_let_day,velib_curr_day] = donneesJours(velib_take,velib_let,velib_curr)
	[velib_take_day,velib_let_day,velib_curr_day] = compact(velib_take,velib_let,velib_curr,144);
end

%données compacté heures par heures
function [velib_take_hour,velib_let_hour,velib_curr_hour] = donneesHeures(velib_take,velib_let,velib_curr)
	[velib_take_hour,velib_let_hour,velib_curr_hour] = compact(velib_take,velib_let,velib_curr,144);
end

%filtre gaussien
function [velib_take_gauss,velib_let_gauss,velib_curr_gauss] = filtreGauss(velib_take,velib_let,velib_curr,taille)
	velib_take_gauss = [];
	velib_let_gauss = [];
	velib_curr_gauss = [];

	for i=1:size(velib_curr,2)

		if(i-taille/2<=0)	%début 

			curr = mean(velib_curr([1:i+taille/2]));
			let = mean(velib_let([1:i+taille/2]));
			take = mean(velib_take([1:i+taille/2]));

		elseif(i+taille/2>size(velib_curr,2))	%fin

			curr = mean(velib_curr([i-taille/2:size(velib_curr,2)]));
			let = mean(velib_let([i-taille/2:size(velib_curr,2)]));
			take = mean(velib_take([i-taille/2:size(velib_curr,2)]));
			
		
		else %cas central

			curr = mean(velib_curr([i-taille/2:i+taille/2]));
			let = mean(velib_let([i-taille/2:i+taille/2]));
			take = mean(velib_take([i-taille/2:i+taille/2]));
			

		end
		velib_curr_gauss = [velib_curr_gauss curr];
		velib_let_gauss = [velib_let_gauss let];
		velib_take_gauss = [velib_take_gauss take];
	end
end