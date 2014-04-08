clear all;
close all;
%velib.m;
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

%===================-~	PRE TRAITEMENT

[infostationsP] = permutToInfoStation(infostations,id2stations);
[velib_take,velib_let,velib_curr, out] = enleverInactive(velib_take,velib_let,velib_curr,infostationsP);
[velib_take_N,velib_let_N,velib_curr_N] = normMax(velib_take,velib_let,velib_curr);
[velib_diff] = diffData(velib_take_N,velib_let_N);

disp("==============PRE TRAITEMENT==================");
outsize = size(out,1);
fprintf(" %d stations ont été retirées pour activitée nulle\n", outsize);
out'
fflush(stdout);




%===================-~	POST TRAITEMENT 

disp("==============POST TRAITEMENT==================");
disp("==============Kmean sur l\'activitée");

[centers, ypred] = kmeans(velib_diff,3);
plotStationsParisCouleur(infostations,ypred);

%plotStationsParis(infostations);
%clusters=floor(rand(size(infostations,1),1).*10+1);



%[donneesEtats] = transformeEtats(3,velib_curr_N);
%[chaine] = initChaineMarkov(3,donneesEtats);
%[clusters , chaines] = clustersCM(3,3,donneesEtats,3);
%like = likelyhoodSeqCM(donneesEtats(1,:),chaine);
