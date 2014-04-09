%velib_functions_plot.m
%Conventions: DATA = [LET]-[TAKE]-[CURRENT]
%affiche l'activité generale
function [] = plotActiviteGenerale(velib_take_hour, velib_let_hour)
figure
plot(sum(velib_take_hour + velib_let_hour,1));
title("activite heure par heure");
end

function [] = plotDiffActiviteGenerale(velib_diff)
figure
plot(sum(velib_diff,1));
title("difference d'activite heure par heure");
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


%affiche les stations de paris avec != couleurs en fonction de numeros
function [] = plotStationsParisCouleur(infostations, numeros,cmap)
		figure;

		coord = infostations(:,[2,3]);

		ind = find(coord(:,1)==0);
		ind2 = find(coord(:,2)==0);
		coord(ind,1) = 2.33;
		coord(ind2,2) = 48.8;

	for i=1:max(numeros)
		plot(coord(numeros==i,1),coord(numeros==i,2),"*", "color", cmap(i,:));
		hold on;
	end
	hold off;
	
end



function [] = afficheDiffStationsMean(velib_diff,clusters,cmap)

	figure;

	for i=1:(max(clusters))
		part = velib_diff(clusters==i,:);
		plot(mean(part,1),"color",cmap(i,:));
		hold on;
	end
	hold off;
end

