clear all;
close all;
%velib.m;
source('velib_functions.m');

infostations = load("infostations.csv");
velib_let = load("lettab.csv");
velib_take = load("taketab.csv");
velib_curr = load('curtab.csv');

[velib_takeN,velib_letN,velib_currN] = normMax(velib_take,velib_let,velib_curr);
[velib_take_day,velib_let_day,velib_curr_day] = donneesJours(velib_take,velib_let,velib_curr,100);
[velib_take_gauss,velib_let_gauss,velib_curr_gauss] = filtreGauss(velib_take,velib_let,velib_curr,5)



