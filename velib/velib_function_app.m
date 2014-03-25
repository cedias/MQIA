%velib_function_app

%chaine de markov a initialisation uniforme
function [chaine] = initChaineMarkov(nbetats,matSequences)
	%chaine{1}:Etats
	%chaine{2}:Mat Transitions
	%chaine{3}:Mat InitUniforme
	chaine{1} = [1:nbetats];
	chaine{2} = zeros(nbetats);
	chaine{3} = ones(nbetats,1)./nbetats;
end

function [chaine] = (chaine,matSequences)
	chaine

end