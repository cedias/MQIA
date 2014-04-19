clear all;
close all;
%velib.m;
%Charles-Emmanuel Dias - 2014

%sourcing
source('velib_functions_base.m');
source('velib_functions_app.m');
source('velib_functions_plot.m');
source('hmm.m');

%load data
infostations = load("infostations.csv");
id2stations = load('id2stations.csv');
velib_let = load("lettab.csv");
velib_take = load("taketab.csv");
velib_curr = load('curtab.csv');

%%%%%%%- CONSTANTES -%%%%%%%

CLUDIFF = 2;
CLUACTI = 4;
NBETAT = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===================-~
%   PRE TRAITEMENT
%===================-~	
[infostations] = permutToInfoStation(infostations,id2stations);
[velib_take,velib_let,velib_curr,infostations, out] = enleverInactive(velib_take,velib_let,velib_curr,infostations);
[velib_take,velib_let,velib_curr] = normMax(velib_take,velib_let,velib_curr);

%AFFICHAGE

		disp("==============PRE TRAITEMENT==================");
		fprintf(" %d stations ont été retirées pour activitée nulle\n",size(out,1));
		out'
		fflush(stdout);
%

%===================-~
% 	MISE EN FORME
%===================-~
[velib_take_hour,velib_let_hour,velib_curr_hour] = donneesHeures(velib_take,velib_let,velib_curr);
[velib_take_day,velib_let_day,velib_curr_day] = donneesJours(velib_take,velib_let,velib_curr);
[velib_diff] = diffData(velib_take_hour,velib_let_hour);
[weekend] = getWeekEndData(velib_take,velib_let,velib_curr);
[week] = getWeekData(velib_take,velib_let,velib_curr);



%===================-~
% 	GENERALITES
%===================-~
disp("==============GENERALITES==================");
disp("==============Activité par jours");
agPlot = plotActiviteGenerale(velib_take_hour,velib_let_hour);
saveas(agPlot,"activiteHpH.eps","epsc")
diffPlot = plotDiffActiviteGenerale(velib_diff)
saveas(diffPlot,"activiteDiffHpH.eps","epsc")


%===================-~	POST TRAITEMENT 
disp("==============POST TRAITEMENT==================");
disp("==============Kmean sur le delta d\'activitée");


%==~ KMEANS - Delta Activité

cmap = jet(CLUDIFF);
[centers, clusters] = kmeans(velib_diff,CLUDIFF);

stDaPlot = plotStationsParisCouleur(infostations,clusters,cmap);
title("clusters des Stations");
saveas(stDaPlot,"stationDiffCluster.eps","epsc")

diffClust = afficheDiffStationsMean(velib_diff,clusters,cmap);
title("Difference d'activitee moyenne des stations par clusters");
saveas(diffClust,"diffHpHClust.eps","epsc")

stationDep = find(clusters==1);
stationArr = find(clusters==2);

afficheDiffStationPerDay(week,weekend,clusters,cmap);
diffWW = afficheDiffWeekWeekend(week,weekend,clusters,cmap);
saveas(diffWW,"diffWW.eps","epsc")


%==~ KMEANS - Activité totale

disp("==============Kmean sur l\'activité totale");

cmap = jet(CLUACTI);
ag = velib_take_hour + velib_let_hour;
[centers, clusters2] = kmeans(ag,CLUACTI);
activClu = plotStationsParisCouleur(infostations,clusters2,cmap);
saveas(activClu,"activClu.eps","epsc");
activMean = afficheActivGenMean(ag,clusters2,cmap);
saveas(activMean,"activMean.eps","epsc");
%{
%==~ Multicluster

clusters3 = sum([clusters*10 clusters2],2); %% Marche seulement si moins 9 clusters
c3 = clusters3;
j=1;
for i  = unique(c3)'
	clusters3(c3==i) = j;
	j= j+1;
end
cmap = jet(size(unique(clusters3),1));
stationsMulti = plotStationsParisCouleur(infostations,clusters3,cmap);
title("Tous les clusters")
saveas(stationsMulti,"stMult.eps","epsc");
diffClustMulti = afficheDiffStationsMean(velib_diff,clusters3,cmap);
saveas(diffClustMulti,"diffMult.eps","epsc");
activMeanMulti = afficheActivGenMean(ag,clusters3,cmap);
saveas(activMeanMulti,"actiMulti.eps","epsc");



==~ Chaines Markov



disp("==============Markov sur le Multicluster");

cmp = summer(8);
disp('choix NBETAT');
for j=unique(clusters3)'
	fprintf("cluster %d/8\n",j);
	fflush(stdout);
	ml =[];
	for i=2:10
		velib_etat = transformeEtats(i,velib_diff);
		part = velib_etat(clusters3==j,:);
		chaineTest = initChaineMarkov(i,part);
		ml = [ml likelyhoodMeanData(part,chaineTest)];
	end
	plot(ml,"color",cmp(j,:));
	hold on;
end
hold off;


velib_etat = transformeEtats(NBETAT,velib_diff);
disp("==============Chaines directes");

cmap = jet(NBETAT);

chainesDiff = {};
moylkl = [];
for i = unique(clusters3)'
	part = velib_etat(clusters3==i,:);
	chainesDiff{i} = initChaineMarkov(NBETAT,part);

	ml = likelyhoodMeanData(part,chainesDiff{i});
	moylkl = [moylkl ml];
end


disp('Moyenne likelyhood clusters/chaines');
moylkl

disp("==============Sous clusters");

cmap = jet(2);
for i = unique(clusters3)'
	part2 = velib_etat(clusters3==i,:);
	[clusters , chaines] = clustersCM(NBETAT,2,part2,5);
	%stationsMulti = plotStationsParisCouleur(infostations(clusters3==1,:),clusters,cmap);
	for j=1:2
		ml = likelyhoodMeanData(part2(clusters==j,:),chaines{j});
		fprintf("cluster %d, sousCluster %d",j);
		fflush(stdout);
		ml
	end
end



disp("==============Markov sur EM");

cmap = jet(2);
[donneesEtats] = transformeEtats(NBETAT,velib_diff);
[clusters , chaines] = clustersCM(NBETAT,2,velib_etat,5);
plotStationsParisCouleur(infostations,clusters,cmap);
diffClustEM = afficheDiffStationsMean(velib_diff,clusters,cmap);
saveas(diffClustEM,"diffClustEM.eps","epsc");
agClustEm = afficheActivGenMean(ag,clusters,cmap);
saveas(agClustEm,"agClustEm.eps","epsc");

moylkl = [];
for i = unique(clusters)'
	part = velib_etat(clusters==i,:);
	ml = likelyhoodMeanData(part,chaines{i});
	moylkl = [moylkl ml];
end
moylkl
%}
%==~HMM
velib_etat = transformeEtats(NBETAT,velib_diff);
M = ApprendMMC(velib_etat,NBETAT,2);
