%velib_functions_plot.m
%Conventions: DATA = [LET]-[TAKE]-[CURRENT]
%affiche l'activité generale
function [fig] = plotActiviteGenerale(velib_take_hour, velib_let_hour)
fig = figure
plot(sum(velib_take_hour + velib_let_hour,1));
title("activite heure par heure");
end

function [fig] = plotDiffActiviteGenerale(velib_diff)
fig = figure
plot(mean(velib_diff,1));
title("moyenne difference d'activite heure par heure");
end

%affiche les stations de paris /!\ stations 0 0 /!\
function [fig] = plotStationsParis(infostations)
	coord = infostations(:,[2,3]);
	ind = find(coord(:,1)==0);
	ind2 = find(coord(:,2)==0);
	coord(ind,1) = 2.33;
	coord(ind2,2) = 48.8;
	plot(coord(:,1),coord(:,2),"r+");
end


%affiche les stations de paris avec != couleurs en fonction de numeros
function [fig] = plotStationsParisCouleur(infostations, numeros,cmap)
		fig = figure;

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



function [fig] = afficheDiffStationsMean(velib_diff,clusters,cmap)

	fig = figure;

	for i=1:(max(clusters))
		part = velib_diff(clusters==i,:);
		plot(mean(part,1),"color",cmap(i,:));
		hold on;
	end
	hold off;
end

function [fig] = afficheDiffStationPerDay(week,weekend,clusters,cmap)

	fig = figure;
	for i=1:5
		day = week{i}; %get day data
		dayDiff = day{1}-day{2}; %let - take = diff
		subplot(2,5,i);
		for j=1:(max(clusters))
			part = dayDiff(clusters==j,:);
			plot(mean(part,1),"color",cmap(j,:));
			title(["jour " int2str(i)])
			hold on;
		end
		hold off;
	end

	for i=1:2
		day = weekend{i}; %get day data
		dayDiff = day{1}-day{2}; %let - take = diff
		subplot(2,5,i+5);

		for j=1:(max(clusters))
			part = dayDiff(clusters==j,:);
			plot(mean(part,1),"color",cmap(j,:));
			title(["jour " int2str(i+5)])
			hold on;
		end
		hold off;
	end

end


function [fig] = afficheDiffWeekWeekend(week,weekend,clusters,cmap)

	fig = figure;

	for i=1:5
		day = week{i}; %get day data
		dayDiff = zeros(size(day,1),size(day,2),5);
		dayDiff(:,:,i) = day{1}-day{2}; %let - take = diff
	end

		dayDiff = mean(dayDiff,3);
		part = dayDiff(clusters==j,:);
		subplot(1,2,1)
		plot(mean(part,1),"color",cmap(j,:));


	for i=1:2
		day = weekend{i}; %get day data
		dayDiff = zeros(size(day,1),size(day,2),5);
		dayDiff(:,:,i) = day{1}-day{2}; %let - take = diff
	end

		dayDiff = mean(dayDiff,3);
		part = dayDiff(clusters==j,:);
		subplot(1,2,2)
		plot(mean(part,1),"color",cmap(j,:));

end



