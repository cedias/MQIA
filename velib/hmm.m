%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function O=Tire_Loi(L)
LS=cumsum(L);
Temp=find(LS>=rand);
O=Temp(1);
end;

function R=normaliseV(V)
R=V / sum(V);
end;

function R=normaliseM(A)
R=A./repmat(sum(A')',1,size(A)(2));
end;

%% retourne dans S une sequence de longueur T générée avec le MMC M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q,O]=genereMMC(M, T)
PI = M{1};
A = M{2};
B=M{3};
K = length(PI); % #symboles
Q=zeros(1,T);
O=zeros(1,T);
Q(1)=Tire_Loi(PI);
O(1)=Tire_Loi(B(Q(1),:));	
for t=2:T
	Q(t) = Tire_Loi(A(Q(t-1),:));
	O(t)=Tire_Loi(B(Q(t),:));	
end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p=CalculeProbaMMC_GD(M, O)
PI = M{1};
A = M{2};
B=M{3};
K = length(PI); % #symboles
T=length(O)
Alphas=zeros(K,T);
Alphas(:,1)= PI' .* B(:,O(1));
for t=2:T
	Alphas(:,t) = (A' * Alphas(:,t-1)) .* B(:,O(t)) ;
end;
p=Alphas(K,T);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p=CalculeProbaMMCApprox_GD(M, O)
PI = log(M{1});
A = log(M{2});
B = log(M{3});
K = length(PI); % #symboles
T=length(O);
Deltas=zeros(K,T);
Deltas(:,1)= PI' + B(:,O(1));
for t=2:T
	[Deltas(:,t), JJ] = max (  (A' + repmat(Deltas(:,t-1)',K,1))') ;
	Deltas(:,t) = Deltas(:,t) + B(:,O(t)) ;
end;
Deltas;
p= Deltas(K,T);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Q=backtrack(Psis,sfinal)
T=size(Psis)(2);
Q=zeros(1,T);
Q(T)=sfinal;
for t=T-1:-1:1
  Q(t)=Psis(Q(t+1),t+1);
  end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,Q]=DecodeMMC_GD(M, O)
PI = log(M{1});
A = log(M{2});
B = log(M{3});
K = length(PI); % #symboles
T=length(O);

Deltas=zeros(K,T);
Psis=zeros(K,T);

Deltas(:,1)= PI' + B(:,O(1));
Psis(:,1)=-1*ones(K,1);

for t=2:T
	[Deltas(:,t), Psis(:,t)] = max (  (A' + repmat(Deltas(:,t-1)',K,1))') ;
	Deltas(:,t) = Deltas(:,t) + B(:,O(t)) ;
end;
Deltas;
Psis;
[p, smax]=max(Deltas(:,T));
smax = K; % ajout GD
Q=backtrack(Psis,smax);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%init de matrice de comptage pour un mmc à K états et M symboles observables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M=InitZerosMMC(M,K)
PI=zeros(1,K);
A=zeros(K,K);
B=zeros(K,M);
M={PI,A, B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Comptages pour une segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Stats=CompteMMC_GD(M, O, K)
PI=zeros(size(M{1}));
A=zeros(size(M{2}));
B=zeros(size(M{3}));
O;
M;
[p,Q]=DecodeMMC_GD(M,O);
T=length(Q);
O;
Q;
PI(Q(1)) = PI(Q(1))+1;
B(Q(1),O(1)) = B(Q(1),O(1))+1; 
for t=2:T
	A(Q(t-1),Q(t)) = A(Q(t-1),Q(t)) +1;
	B(Q(t),O(t)) = B(Q(t),O(t))+1; 
end;
Stats={PI, A, B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Stats=CompteMMCAlignLin_GD(O, V, K)
PI=zeros(1,K);
A=zeros(K,K);
B=zeros(K,V);
T=length(O);
Duree = floor(T/K);
Q= ones(T)*K;
for i=1:K-1
  imin=Duree*(i-1)+1;
  imax=Duree*i;
  Q(imin:imax)=i;
  end;
PI(Q(1)) = PI(Q(1))+1;
B(Q(1),O(1)) = B(Q(1),O(1))+1; 
for t=2:T
	A(Q(t-1),Q(t)) = A(Q(t-1),Q(t)) +1;
	B(Q(t),O(t)) = B(Q(t),O(t))+1; 
end;
Stats={PI, A, B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = InitMMC(X,V,K)
PI=normaliseV(rand(1,K));  
A=normaliseM(rand(K,K));
B=normaliseM(rand(K,V));
M={PI,A,B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = InitMMCGD2(X,V,K)
PI=zeros(1,K);PI(1)=1;  
D1=zeros(1,K);
D2=zeros(1,K);
D1(1)=1;
if (K>1) D2(2)=1; end;
A=normaliseM(toeplitz(D1,D2));
B=normaliseM(rand(K,V));
M={PI,A,B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = InitMMCGD(X,V,K)
PI=zeros(1,K);PI(1)=1;  
D1=zeros(1,K);
D2=zeros(1,K);
D1(1)=1;
if (K>1) D2(2)=1; end;
A=normaliseM(toeplitz(D1,D2));
B=normaliseM(rand(K,V));
M={PI,A,B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = InitMMCAlignGD(X,V,K)
N=size(X)(1); % Nb séquences app
Stats=InitZerosMMC(V, K);	
PI=Stats{1};
A=Stats{2};
B=Stats{3};
for i=1:N
     StatsTemp=CompteMMCAlignLin_GD(X(i,:),K); 
     PI = PI + StatsTemp{1};
     A = A + StatsTemp{2};
     B = B + StatsTemp{3};
end;
M= reestimeMMCGD(A,B,PI);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = reestimeMMCGD(A,B,PI)      
  lissage=0;
  if (lissage ==1) 
    PI = PI + ones(size(PI));
    A = A + ones(size(A));
    B = B + ones(size(B));
    end;
  PI= normaliseV(PI);
  A=normaliseM(A);
  B=normaliseM(B);
  M={PI,A,B};
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Pmoy = CalculeProbaBaseMMCGD(M, X)
  N=size(X)(1); % Nb séquences app
  Ptot=0;
  for i=1:N
          [p,Q]=DecodeMMC_GD(M, X(i,:));
          Ptot += p;
  end;
  Pmoy=Ptot/N;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X = base de séquences (une par ligne)
% K = nb symboles
% MMC GD Discret 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M=ApprendMMCGD(X, K, V)
M=InitMMCGD(X,V,K);
N=size(X)(1); % Nb séquences app
Ite=1;
IteMax=10;
while (Ite<IteMax)
  Stats=InitZerosMMC(V, K);	
  %M=InitMMC(X,V,K);
  PI=Stats{1};
  A=Stats{2};
  B=Stats{3};
  for i=1:N
          StatsTemp=CompteMMC(M, X(i,:),K); 
          PI = PI + StatsTemp{1};
          A = A + StatsTemp{2};
          B = B + StatsTemp{3};
  end;
  %lissage
	M= reestimeMMCGD(A,B,PI);

	Pmoy= CalculeProbaBaseMMCGD(M,X); 
	Ite+=1;
  end;
end;	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X = base de séquences (une par ligne)
% K = nb symboles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M=ApprendMMC(X, K, V)
M=ApprendMMCGD(X,K,V);
end;	

%%%%%%%%%%% fonctions à instancier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M=Apprend(X,K)
NB_etatsGD=6;
M=ApprendMMC(X, NB_etatsGD, K, 1);
end;
