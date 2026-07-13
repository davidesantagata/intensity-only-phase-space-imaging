function [Y] = fourierTransform(x, y, k0, pmax, M)
    
    % Determinare la lunghezza del segnale
    N = size(y, 1);
 
    % Creazione dell'asse della frequenza spaziale
    p = linspace(-pmax, pmax, M);  % Campionamento delle frequenze spaziali

    %dp = 2 * pmax / (M - 1);          % Passo di campionamento in p
    dx = x(2)-x(1);                    % Passo di campionamento in x (spazio o tempo)

    % Costruzione della matrice esponenziale per la trasformata
    E = exp(1i*k0*p(:)*x);

    % Calcolo della trasformata di Fourier
    Y = E * y * dx; 

end
