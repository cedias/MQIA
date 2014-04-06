%velib_functions_plot.m
%Conventions: DATA = [LET]-[TAKE]-[CURRENT]
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