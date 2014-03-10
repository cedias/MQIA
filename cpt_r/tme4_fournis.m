##############################################################
##### Fonctions d'activations et leurs dérivées
##############################################################

# Fonction d'activation sigmoide
function vec=sigmo(x, alpha, beta)
vec = alpha * tanh(beta * x);
endfunction;

function vec=df_sigmo(x, alpha, beta)
vec = alpha * beta * (1- tanh(beta*x).*tanh(beta*x));
endfunction

# Fonction d'activation linéaire
function vec=flin(x)
vec = x;
endfunction

# Fonction d'activation linéaire
function vec=dflin(x)
vec = ones(size(x));
endfunction

# Fonction qui calcule l'activation des neurones de la couche cachée.
function vec=f_ccs(x)
vec = sigmo(x, 1.7, 0.6);
endfunction

function vec=df_ccs(x)
vec = df_sigmo(x, 1.7, 0.6);
endfunction

# Fonction qui calcule l'activation des neurones de la couche de sortie.
function vec=f_sorties(x)
vec=flin(x);
endfunction

# Fonction qui calcule l'activation des neurones de la couche de sortie.
function vec=df_sorties(x)
vec=dflin(x);
endfunction

##############################################################
##### Fonction d'initialisation
##############################################################

#Fontion d'init d'un pmc
########################

function [pmc] = init_pmc (ni, no, Nccs)
nb_HL = length(Nccs); #nb_couches_cachees === Hidden Layers
couches={};
nbamont = ni;
Etats= zeros(ni,1);
Sorties= zeros(ni,1);
W=zeros(ni,1);
couches{1}={Etats, Sorties, W, "flin", "dflin"};

for h=1:nb_HL
	# Vecteur de poids entre les neurones de la couche entrée vers ceux de la couche cachée ; initialisé aléatoirement
	nbaval = Nccs{h};
	Etats = zeros(nbaval,1);
	Sorties = zeros(nbaval,1);
	W = 1/ sqrt(nbamont) *randn(nbaval,nbamont+1);
	couches{h+1}={Etats, Sorties,  W, "f_ccs", "df_ccs"};
	nbamont = nbaval;
	end;
nbaval = no;
Etats = zeros(nbaval,1);
Sorties = zeros(nbaval,1);
W= 1/ sqrt(nbamont) * randn(no,nbamont+1);
couches{nb_HL+2} = {Etats, Sorties, W, "f_sorties", "df_sorties"};
pmc = couches;
end;

##############################################################
##### Fonctions de propagation avant
##############################################################

function [p]=put(pmc, x)
pmc{1}{1}=x;
pmc{1}{2}=x;
p=pmc;
end;

%pmc{1}{1}Etat (in)
%pmc{1}{2}Sortie (out)
%pmc{1}{3}W (poids)
%pmc{1}{4} fonction d'activation
%pmc{1}{5} deriv fonction d'activation
function [y, p] = propage_avant(pmc)
etat = pmc{1}{1};
for h=2:length(pmc)
	%in+1
	pmc{h}{1} = [1;etat]; %peut etre en ligne
	%stocker a
	pmc{h}{2} = pmc{h}{3}*pmc{h}{1};
	%out<-g(in*w)
	etat = feval(pmc{h}{4},pmc{h}{2});
end;
y = etat;
p = pmc;
end;