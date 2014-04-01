clear all;
close all;
%velib.m;
source('velib_functions_base.m');
source('velib_functions_plot.m');
source('velib_functions_app.m');

infostations = load("infostations.csv");
velib_let = load("lettab.csv");
velib_take = load("taketab.csv");
velib_curr = load('curtab.csv');

weekend = getWeekEndData(velib_take,velib_let,velib_curr);
week = getWeekData(velib_take,velib_let,velib_curr);
[velib_take_N,velib_let_N,velib_curr_N] = normMax(velib_take,velib_let,velib_curr);


[donneesEtats] = transformeEtats(3,velib_curr_N);
[chaine] = initChaineMarkov(3,donneesEtats);

