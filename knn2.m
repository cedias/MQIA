function [ypred,tabkppv,distance,vote,conf]=knn2(xapp,yapp,valY,X,k)

%
% knn implementation
%
% USE : [ypred,tabkppv,distance,vote,conf]=knn(xapp,yapp,valY,X,k)
%
% xapp, yapp : learning data
% valY : all the Y value possible
% X : data to be classified
% k : number of nearest neighbours
%
% ypred : class of X
% tabkppv : [nbpts x nbpts] index of nearest neighbours
% distance : [nbpts x nbpts] distance
%

% Vincent Guigue 08/01/03

% check nargin

if nargin<3
  error('too few argumemnts');
elseif nargin<4
  X=xapp;
elseif nargin<5
  k=3;
end

if size(xapp,2)~=size(X,2)
  error('dimension incompatibility');
end


% taille des matrices
ndim = size(xapp,2);
nptxapp = size(xapp,1);
nptX = size(X,1);

% distance de X a xapp :
mat1     =  repmat(xapp, nptX,1);
mat22    = repmat(X,1,nptxapp)';
mat2     = reshape(mat22 ,ndim, nptxapp*nptX)';
distance = mat1 - mat2 ;

distance = sum(distance.^2,2); % on laisse la distance au carre
distance = reshape(distance,nptxapp,nptX);
[val kppv] = sort(distance,1);

tabkppv = kppv(1:k,:); % table des kppv

% bilan sur les k premieres lignes
kppv = reshape(kppv(1:k,:),k*nptX,1);
Ykppv = yapp(kppv,1);
Ykppv = reshape(Ykppv,k,nptX);

% trouver le plus de reponses identique par colonne

vote = [];
for i=1:nptX
  for j=1:length(valY)
    vote(j,i)=size(find(Ykppv(:,i)==valY(j)),1);
  end
end

[val ind]=max(vote,[],1);
ypred = valY(ind);
conf = val/k;