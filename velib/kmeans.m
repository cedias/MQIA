function [centers, ypred] = kmeans(x,ncenters, niter, centers)
%
% USE : 
%     [centers, ypred] = kmeans(x,ncenters, [OPT] niter, [OPT] centers)
% 
%   x : donnees a apprendre
%   ncenters : argument k, nombre de moyennes
%   niter : nombre d'iteration de kmeans (1000 par defaut)
%   centers : initialisation des centres (aléatoire par defaut)
% 
%   Les arguments et les retours parlent d'eux même...
% 

epsilon = 1e-3;
ndim = size(x,2);
npts = size(x,1);

if nargin < 4
  tmp = randperm(npts);
  centers = x(tmp(1:ncenters),:); % certain points de la base.
endif
if nargin < 3
  niter = 1000;
endif


fprintf("%10s | %10s\n", "iter", "Sum Mvt");
iter = 0;
while (true)
  
	%recuperer les classes en fonction des points
	[ypred] = kmeans_knn(centers,[1:ncenters]',[1:ncenters],1,x);

  newcenters = zeros(ncenters, ndim);

  for i=1:ncenters

	  index = find(ypred==i);

   if (length(index)>0)
	
	newcenters(i,:) = mean(x(index,:))

    else % disparition d'un centre...
      newcenters(i,:) = x(ceil(rand*npts),:)
      fprintf("** ");
    endif 
  endfor
  iter++;
  sumMvt = mean(sqrt(sum( (newcenters-centers).^2 ))) ;
  
  fprintf("%10d | %10e\n", iter, sumMvt); fflush(stdout);

  centers = newcenters;
 
  % critere d'arret
  if iter > niter
    break;
  endif

  if sumMvt < 1e-6
    break;
  endif
endwhile