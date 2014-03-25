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
week= getWeekData(velib_take,velib_let,velib_curr);
