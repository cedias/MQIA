%
% Plot the decision frontier f(x,y) = 0 (or the surface f)
% USE: plotFrontiere(xgrid, ygrid, surface)
%
% Arguments:
%  xgrid: grid on the bounding box of the data (cf generateGrid)
%  ygrid: evaluation of the grid by the model
%  [OPT] surface : if any value here -> plot the surface instead of the frontier
%
function plotFrontiere(xgrid, ygrid, surface)


ngrid = round(sqrt(length(xgrid)));
ygrid = reshape(ygrid, ngrid, ngrid);
x1grid= reshape(xgrid(:,1), ngrid, ngrid);
x2grid= reshape(xgrid(:,2), ngrid, ngrid);

if(nargin < 3)
  [gg,hh] = contour(x1grid, x2grid,ygrid,[0 0]);
  set(hh,'linewidth',2);
  %get(hh)
  set(hh,'linecolor','k');

else
    surf(x1grid, x2grid,ygrid);
end
