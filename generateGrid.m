%
% Build a grid on the bounding box of the data x
%
% USE: xgrid=generateGrid(x, ngrid)
% 
% Arguments:
%   x : data 2D (N rows, 2 columns)
%   [OPT] ngrid : nb points in the grid, default=30
%
function xgrid=generateGrid(x, ngrid)

if nargin < 2
    ngrid =30;
end
xmin = min(x);
xmax = max(x);

[x1grid, x2grid] = meshgrid(linspace(xmin(1), xmax(1), ngrid), ...
			    linspace(xmin(2), xmax(2), ngrid));

xgrid = [reshape(x1grid, ngrid*ngrid,1) reshape(x2grid, ngrid*ngrid,1)];
