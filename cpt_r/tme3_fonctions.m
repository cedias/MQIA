%%%% W vecteur ligne
%%%% Base = array d'entrées  et sorties (individus en ligne)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Utilitaires pour les bases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function N=nbexemples(Base)
N=size(Base{1},1);
end;


function Base = MelangeAleatBase(Base)
N=nbexemples(Base);
p=randperm(N);
L=length(Base);
if (L==1)  BaseTemp = {Base{1}(p,:)};
else BaseTemp = {Base{1}(p,:), Base{2}(p,:)};	
end;
end;


function BaseTemp = ieme_exemple(k,Base)
L=length(Base);

if (L==1) BaseTemp = {Base{1}(k,:)};
	else
	BaseTemp = {Base{1}(k,:), Base{2}(k,:)};	
end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Fonctions de gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Fonction d'initialisation du vecteur de poids

function w= init_params(Base)
w=randn(size(Base{1})(2),1)*5+ones(size(Base{1})(2),1)*2;
end;


%%%%%%%%%%%%%%%%%%%%%
function mse = cout_mse(W,Base)
Inputs=Base{1};
Outputs=Base{2};
mse=mean((W' * Inputs' - Outputs') .^2);
end;

function d_mse = dcout_mse(W,Base)
Inputs=Base{1};
Outputs=Base{2};
d_mse= (1 / size(Inputs,1)) * 2 * (W' * Inputs' - Outputs') * Inputs;
end;


%%%%%%% Fonctions de gradient Batch

function [W, C] = optimise_gradient_batch(Base, epsi, rate_epsi, winit , cout, dcout )
nbitemax = 200;
wcour = winit;
W = [];
C = [cout(wcour,Base)];
for i = 1: nbitemax
	wcour = wcour - epsi* dcout(wcour, Base)';	
	epsi *= rate_epsi;
	W = [W wcour];
	C = [C; cout(wcour,Base)];

end;
end;

%%%%%%% Fonctions de gradient Stochastique

function [W, C] = optimise_gradient_stoch(Base, epsi, rate_epsi, winit , cout, dcout )
nbitemax = 200;
wcour = winit;
Base=MelangeAleatBase(Base);
N=nbexemples(Base);
W = [];
C = [cout(wcour,Base)];

for i = 1: nbitemax
	for k=1:N
		BaseTemp=ieme_exemple(k, Base);
		wcour = wcour - epsi* dcout(wcour, BaseTemp)';
		W = [W wcour];
		C = [C; cout(wcour,Base)];
	end;
	epsi *= rate_epsi;
end;
end;









