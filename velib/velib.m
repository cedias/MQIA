clear all;
close all;
%velib.m;
source('velib_functions.m');

infostations = load("infostations.csv");
velib_let = load("lettab.csv");
velib_take = load("taketab.csv");
velib_curr = load('curtab.csv');

[velib_takeN,velib_letN,velib_currN] = normMax(velib_take,velib_let,velib_curr);