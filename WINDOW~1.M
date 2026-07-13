function R = windowingInversion(sigma2, gamma, m, x, L, N)
% WINDOWINGINVERSION
%   Scheletro della funzione per applicare una finestra e 
%   svolgere una procedura di inversione.
%
% INPUT:
%   var   : parametro di varianza o smoothing
%   gamma : parametro di pesatura / finestra
%   E     : campo o matrice dei dati (NxN oppure vettore)
%   x     : coordinate spaziali
%
% OUTPUT:
%   R     : vettore ricostruito

etaMax = gamma*sqrt(2/sigma2);

a = exp(-x.^2/(2*sigma2));

eta = linspace(-etaMax, etaMax, N);
H = fourierTransform(x, m(:), 1, etaMax, N);
A = fourierTransform(x, abs(flip(a(:))).^2, 1, etaMax, N);

R = abs(fourierTransform(eta, H./A, -1, L/2, N)).';

end
