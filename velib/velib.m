clear all;
close all;
%velib.m;
%Charles-Emmanuel Dias - 2014

%sourcing
source('velib_functions_base.m');
source('velib_functions_app.m');
source('velib_functions_plot.m');

%load data
infostations = load("infostations.csv");
id2stations = load('id2stations.csv');
velib_let = load("lettab.csv");
velib_take = load("taketab.csv");
velib_curr = load('curtab.csv');

%%%%%%%- CONSTANTES -%%%%%%%

CLUDIFF = 2;
CLUACTI = 4;
NBETAT = 3;

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
activMeanMulti = afficheActivGenMean(ag,clusters3,cmap);


%==~ Chaines Markov

disp("==============Markov sur le Multicluster");

velib_etat = transformeEtats(NBETAT,velib_diff);
chainesDiff = {};

for i = unique(clusters3)'
	chainesDiff{i} = initChaineMarkov(NBETAT,velib_etat(clusters3==i,:));
end


disp("==============Markov sur EM");

%cmap = jet(3);
%[donneesEtats] = transformeEtats(3,velib_curr_N);
%[clusters , chaines] = clustersCM(3,3,donneesEtats,3);
%plotStationsParisCouleur(infostations,clusters,cmap);
%}
%like = likelyhoodSeqCM(donneesEtats(1,:),chaine);

%==~HMM