function [ypred, tabkppv, distance, confiance]=kmeans_knn(xapp,yapp,valY,k,X)

%
% knn implementation
%
% USE : [ypred,tabkppv,distance,confiance]=knn(xapp,yapp,valY,k,X)
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

% Vincent Guigue 2009

% check nargin

if nargin<3
  error('too few argumemnts');
end
if nargin<4
  k=3; 
end
if nargin<5
  X=xapp;
end

if size(xapp,2) ~= size(X,2)
  error('dimension incompatibility');
end


% taille des matrices
ndim = size(xapp,2);
nptxapp = size(xapp,1);
nptX = size(X,1);

m1 = diag(xapp * xapp');
m2 = diag(X * X');
m3 = X * xapp';

distance = ones(nptX,1)*m1' + m2*ones(1,nptxapp) - 2 *m3;

if k>1
  [val kppv] = sort(distance,2);
else
  [val kppv] = min(distance,[],2);
endif 
if nargout > 1
  tabkppv = kppv(:,1:k); % table des kppv
endif
%keyboard
% bilan sur les k premieres lignes
kppv = reshape(kppv(:,1:k),k*nptX,1);
ypred = yapp(kppv);
ypred = reshape(ypred,nptX,k);

% trouver le plus de reponses identique par ligne
%keyboard;

confiance = [];

if k>1
  [confiance,indexvote] = max(hist(ypred', valY), [], 1);
  ypred = valY(indexvote);
  confiance /= length(valY);
endif