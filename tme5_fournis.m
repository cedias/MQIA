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

function [y, p] = propage_avant(pmc)
etat = pmc{1}{1};
for h=2:length(pmc)
	etat = [1 ; etat];
	W=pmc{h}{3};
	etat = W * etat;
	pmc{h}{1}=etat;
	f= pmc{h}{4};
	etat = feval(f, etat);
	pmc{h}{2}=etat;
	end;
y = etat;
p=pmc;
end;

##############################################################
##### Fonction pour une itération d'apprentissage
##############################################################

function [p] = retro_propage(pmc, deltas, epsi)
NBC=length(pmc); #couches
ai = pmc{NBC}{1};
df=pmc{NBC}{5};
Deltas = 2* deltas .* feval(df, ai);

for k=NBC:-1:2
	
	W= pmc{k}{3};
	zi = [1 ; pmc{k-1}{2}]; 
	DW = Deltas *  zi';
	pmc{k}{3}=W - epsi*DW;	
	
	df=pmc{k-1}{5};
	ai = pmc{k-1}{1};
	dai = feval(df, ai);
	dai = [1 ; dai];
		
	Deltas = (W' * Deltas) .* dai;
	N=length(pmc{k-1}{1})+1;
	Deltas = Deltas(2:N,:);
	end;
p=pmc;
end;

