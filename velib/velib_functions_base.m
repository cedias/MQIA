%velib_functions_base
%Charles-Emmanuel Dias - 2014

%Conventions: DATA= [LET]-[TAKE]-[CURRENT]
%troncature des données par periodes de 144.
function [velib_take_day,velib_let_day,velib_curr_day] = getDayData(velib_take,velib_let,velib_curr,day)
	velib_take_day = velib_take(:,[day*144-143:day*144]);
	velib_let_day = velib_let(:,[day*144-143:day*144]);
	velib_curr_day = velib_curr(:,[day*144-143:day*144]);
end

%Recuperer les données du weekend (jours 4 et 5)
function [data] = getWeekEndData(velib_take,velib_let,velib_curr)
	[data{1}{1},data{1}{2},data{1}{3}] = getDayData(velib_take,velib_let,velib_curr,4);
	[data{2}{1},data{2}{2},data{2}{3}] = getDayData(velib_take,velib_let,velib_curr,5);
end

%Recuperer les données de la semaine (jours 1,2,3 et 6,7)
function [data] = getWeekData(velib_take,velib_let,velib_curr)
	[data{1}{1},data{1}{2},data{1}{3}] = getDayData(velib_take,velib_let,velib_curr,6); %lundi
	[data{2}{1},data{2}{2},data{2}{3}] = getDayData(velib_take,velib_let,velib_curr,7);
	[data{3}{1},data{3}{2},data{3}{3}] = getDayData(velib_take,velib_let,velib_curr,1);
	[data{4}{1},data{4}{2},data{4}{3}] = getDayData(velib_take,velib_let,velib_curr,2);
	[data{5}{1},data{5}{2},data{5}{3}] = getDayData(velib_take,velib_let,velib_curr,3); %vendredi
end

%enlever stations sans activité.
function [velib_take,velib_let,velib_curr, ind0] = enleverInactive(velib_take,velib_let,velib_curr, infostationsP)
	%indice où max = 0 => pas d'activité
	ind0 = find(maxVeloStations(velib_curr)==0);
	%reeaffectation
	velib_take(ind0',:) = [];
	velib_curr(ind0',:) = [];
	velib_let(ind0',:) = [];
	infostationsP(ind0',:) = [];
end
%nombre max velib par stations
function [maxV] = maxVeloStations(velib_curr)
	maxV = max(velib_curr,[],2);
end

%activité d'une station
function [activ] = activiteStation(velib_take, velib_let, index)
	activ = velib_take(index,:) + velib_let(index,:);
end

%differenciel let-take
function [velib_diff] = diffData(velib_take,velib_let)
	velib_diff = velib_let - velib_take;
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

%donneesCurrent En Etats
function [donneesEtats] = transformeEtats(nbEtats,donneesNorm)
	mini = min(min(donneesNorm));
	maxi = max(max(donneesNorm));
	inter = [mini:((maxi-mini)/nbEtats):maxi];
	donneesEtats = ones(size(donneesNorm));

	for i=2:(size(inter,2))
		donneesEtats((donneesNorm>=inter(i-1) & donneesNorm<inter(i))) = i-1;
	end
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
	[velib_take_hour,velib_let_hour,velib_curr_hour] = compact(velib_take,velib_let,velib_curr,6);
end

%filtre gaussien
function [velib_take_gauss,velib_let_gauss,velib_curr_gauss] = filtreGauss(velib_take,velib_let,velib_curr,taille)
	velib_take_gauss = [];
	velib_let_gauss = [];
	velib_curr_gauss = [];

	for i=1:size(velib_curr,2)

		indMin = max(1,round(i-(taille/2)));
		indMax = min(size(velib_curr,2), round(i+(taille/2)));

		curr = mean(velib_curr(:,[indMin:indMax]),2);
		let = mean(velib_let(:,[indMin:indMax]),2);
		take = mean(velib_take(:,[indMin:indMax]),2);
			
		velib_curr_gauss = [velib_curr_gauss curr];
		velib_let_gauss = [velib_let_gauss let];
		velib_take_gauss = [velib_take_gauss take];
	end
end

%met les infostations dans le bon sens
function [infostationsP] = permutToInfoStation(infostations,id2stations)
	id2stations(:,1)+=1; %indicé à 0 au lieu de 1...
	infostationsP = infostations(id2stations(:,2),:);
end