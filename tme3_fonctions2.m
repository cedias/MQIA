
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Fonctions de gradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%
function mse = cout(W,X,Y)
Inputs=X;
Outputs=Y;
mse=mean((W' * Inputs' - Outputs') .^2);
end;

function d_mse = dcout(W,X,Y)
Inputs=X;
Outputs=Y;
d_mse= (1 / size(Inputs,1)) * 2 * (W' * Inputs' - Outputs') * Inputs;
end;


%%%%%%% Fonctions de gradient Batch

function [wcour] = optimise_gradient_batch(X,Y,iter, epsi, winit , cout, dcout )
nbitemax = 200
wcour = winit';
for i = 1: nbitemax
	wcour = wcour -epsi* dcout(wcour, X,Y)';	

end;
end;

%%%%%%% Fonctions de gradient Stochastique

function [wcour] = optimise_gradient_stoch(X,Y, iter, epsi, winit , cout, dcout )
nbitemax = 200;
wcour = winit';
for i = 1:iter
		ind=randperm(size(X))(1)
		wcour = wcour -epsi* dcout(wcour, X(ind,:),Y(ind)';	
	end;
end;


