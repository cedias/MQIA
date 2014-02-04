function xg = phiGauss(x, phiOption)
%
% USE :  xg = phiGauss(x, phiOption)
%  phiOption = {sigma, muGauss}
%  phiOption est une cell composee de l'ecart-type sigma et des centres des gaussiennes
%

% Vincent Guigue 2009

  muGauss = phiOption{2};
  sigma = phiOption{1};
 

    metric = diag(1./sigma^2);

    ps = x*metric*muGauss'; 

    [nps,pps]=size(ps);

    normx = sum(x.^2*metric,2);

    normxsup = sum(muGauss.^2*metric,2);

    ps = -2*ps + repmat(normx,1,pps) + repmat(normxsup',nps,1) ; 

    xg = exp(-ps/2);

