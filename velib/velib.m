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
ag = sum(velib_take_day + velib_let_day,1);
ag/sum(ag)*100
%plotActiviteGenerale(velib_take_hour,velib_let_hour);
%saveas(1,"activiteHpH.eps","epsc")
plotDiffActiviteGenerale(velib_diff)
saveas(1,"activiteDiffHpH.eps","epsc")


%===================-~	POST TRAITEMENT 
disp("==============POST TRAITEMENT==================");
disp("==============Kmean sur le delta d\'activitée");


NBKM = 2;

cmap = jet(NBKM);
[centers, clusters] = kmeans(velib_diff,NBKM);
plotStationsParisCouleur(infostations,clusters,cmap);
afficheDiffStationsMean(velib_diff,clusters,cmap);

ag2 = velib_take_hour + velib_let_hour;
[centers, clusters2] = kmeans(ag2,NBKM);
plotStationsParisCouleur(infostations,clusters2,cmap);


%plotStationsParis(infostations);
%clusters=floor(rand(size(infostations,1),1).*10+1);

%{
disp("==============Markov sur le delta d\'activitée");
cmap = jet(3);
[donneesEtats] = transformeEtats(3,velib_curr_N);
[clusters , chaines] = clustersCM(3,3,donneesEtats,3);
plotStationsParisCouleur(infostations,clusters,cmap);
%}
%like = likelyhoodSeqCM(donneesEtats(1,:),chaine);
