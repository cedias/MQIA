%velib_function_app
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
	
	matTrans = zeros(nbetats);
	for ech=1:size(matSequences,1);%chaque echantillon
		for trans=2:size(matSequences(ech,:),2) %chaque transition
			matTrans(matSequences(ech,trans-1),matSequences(ech,trans))+=1;
		end
	end
	chaine{2} = matTrans./sum(sum(matTrans));

	chaine{3} = ones(nbetats,1)./nbetats;
end

%Clustering EM
function [clusters , chaines] = clustersCM(nbetats,nbChaines,matSequences,nbIter)
	nbEch = size(matSequences,1);
	%init au hasard
	clusters=round(rand(nbEch,1).*nbChaines);
	%calculer des chaines
	for i=1:nbChaines
		initChaineMarkov(nbetats)
	end
	
	%reaffecter en fonction des vraissemblances
end