clear all;
close all;
source('tme5_fournis.m');
%TME5

function [sortie] = labelToVector(label,nbLabel)
	sortie = zeros(nbLabel,1);
	sortie(label)=1;
endfunction

function [label] = vectorTolabel(vector)
	[osef, label] = max(vector);
endfunction

function [erreurMC,erreurPC,pmc] = train_pmc(x,y,in,out,hidd,epsi,iter)
pmc = init_pmc(in,out,hidd);
erreurMC = [];
erreurPC = [];
for i=1:iter
	perm = randperm(size(x,1));
	dataX = x(perm,:);
	dataY = y(perm,:);
	erreurIT = [];
	erreurPCIT = [];
	

	for j=1:size(x,1)
		pmc = put(pmc,dataX(j,:)');
		[sortie, pmc] = propage_avant(pmc);


		label_sortie = vectorTolabel(sortie);
		if(label_sortie != dataY(j))
			erreurPCIT = [erreurPCIT 1];
		end
		await = labelToVector(dataY(j), size(unique(y),1));
		erreurIT = [erreurIT sum((sortie - await).*(sortie-await))];


		pmc = retro_propage(pmc,sortie - await ,epsi);
	end
	 erreurMC = [erreurMC mean(erreurIT)];
	 erreurPC = [erreurPC ((sum(erreurPCIT)/size(x,1))*100)];

end

endfunction

function [ypred] = classPredPMC(data,pmc)
	ypred = [];

for i=1 : size(data,1)
	pmc = put(pmc,data(i,:)');
	pred = propage_avant(pmc);
	[o, Im] = max(pred);
	ypred = [ypred; Im];
end

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INPUT = 256; %nb_pixels
OUTPUT = 10; %nb_classes
HIDDEN = {10}; %nb couches cachés
EPS = 0.01;
ITERATION = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load("usps_napp10.dat");


[erreurMC, erreurPC, pmc ] = train_pmc(xapp,yapp,INPUT,OUTPUT,HIDDEN,EPS,ITERATION);

subplot(2,2,1);
plot(erreurMC,"r");
subplot(2,2,2);
bar(erreurPC,"r");

pred = classPredPMC(xtest,pmc);
positif = pred;
negatif = pred;
positif(pred==ytest) = 1;
positif(pred!=ytest) = 0;

negatif(pred!=ytest) = 1;
negatif(pred==ytest) = 0;
nbBad = sum(negatif);
nbGood = sum(positif);

taille= size(ytest,1);
subplot(2,2,3);
b = bar([nbGood , nbBad]);


         







