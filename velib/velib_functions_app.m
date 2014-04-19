%velib_function_app
%%Charles-Emmanuel Dias 2014
%%CHAINE MARKOV
	%	-> chaine{1}:Etats
	%	-> chaine{2}:Mat Transitions
	%	-> chaine{3}:Mat InitUniforme

%chaine de markov a initialisation uniforme
function [chaine] = initChaineMarkov(nbetats,matSequences)
	%chaine{1}:Etats
	%chaine{2}:Mat Transitions
	%chaine{3}:Mat InitUniforme
	chaine{1} = [1:nbetats];
	if(!size(matSequences,1)==0)

		matTrans = zeros(nbetats);
		for ech=1:size(matSequences,1);%chaque echantillon
			for trans=2:size(matSequences(ech,:),2) %chaque transition
				matTrans(matSequences(ech,trans-1),matSequences(ech,trans))+=1;
			end
		end
		chaine{2} = matTrans./sum(sum(matTrans));
	else
		chaine{2} =[];
	end

	chaine{3} = ones(nbetats,1)./nbetats;
end

%Clustering EM
function [clusters , chaines] = clustersCM(nbetats,nbChaines,matSequences,nbIter)
	nbEch = size(matSequences,1);
	chaines = {};
	%init au hasard
	clusters=floor(rand(nbEch,1).*nbChaines+1);

	for i=1:nbChaines
		chaines{i} = initChaineMarkov(nbetats,matSequences(clusters==i,:)); %init
	end

	for iter=1:nbIter
		fprintf("iter n°%d\n", iter); fflush(stdout);
		%reaffecter en fonction des vraisemblances
		[ch, clusters] = maxVraisemblanceCM(matSequences,chaines,nbetats,nbChaines);

		%calculer des chaines
		for i=1:nbChaines
			chaines{i} = initChaineMarkov(nbetats,matSequences(clusters==i,:));
		end
	end	
end

%retourne un vecteur colonne qui indique la chaine qui maximise la vraisemblance d'une séquence.
function [chaines, clusters] = maxVraisemblanceCM(matSequences,chaines,nbetats,nbChaines);
	clusters = ones(size(matSequences,1),1);
	for seq=1:size(matSequences,1) %pour chaque sequence
		lklhood = [];
		for cha=1:nbChaines %pour chaque chaine
			lklhood = [lklhood likelyhoodSeqCM(matSequences(seq,:),chaines{cha})];
		end
		[maxVal, maxI] = max(lklhood,[],2);
		clusters(seq) = maxI;
	end 
end

%calcul la likelyhood d'une seq par rapport a une chaine en LOGe()
function [like] = likelyhoodSeqCM(seq,chaine)
	like = log(chaine{3}(seq(1)));
	for i=2:size(seq,2)
		like = like+log(chaine{2}(seq(1,i-1),seq(1,i))); %%%BUG ?
	end
end

%calcul la likelyhood moyenne d'un ensemble de donnée par rapport a une chaine [mean(vecteur),vecteur]
function [meanLkl, like] = likelyhoodMeanData(data,chaine)
	like = [];
	for i=1:size(data,1)
		like = [like likelyhoodSeqCM(data(i,:),chaine)];
	end
	meanLkl = mean(like);
end