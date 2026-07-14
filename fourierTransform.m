function [Y] = fourierTransform(x, y, k0, pmax, M)
    
    N = size(y, 1);
 
    % frequency axis
    p = linspace(-pmax, pmax, M);

    dx = x(2)-x(1);                    % sampling step

    % Fourier operator
    E = exp(1i*k0*p(:)*x);

    % Fourier transform
    Y = E * y * dx; 

end
