function xp = phiPoly(x, n)
% 
% Construction d'un espace polynomial explicite:
% USE:
%   xp = phiPoly(x, n)
%   n: degre du polynome
%

  
  xp = [];
  for i=2:n
    xp = [xp x.^i];
  endfor
  
  if n>=2 && size(x,2) >=2
    xp = [xp x(:,1) .* x(:,2)];
  endif

  xp = [xp ones(size(x,1),1)];

  
endfunction
