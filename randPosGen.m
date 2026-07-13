function x = randPosGen(N,L,DX)
% Generate N positions uniformly in [-L/2,L/2]
% with minimum distance DX.

% feasibility check
if (N-1)*DX > L
    error('Impossible Configuration.');
end

x = zeros(1,N);

for i = 1:N
    while true

        % Estrazione uniforme
        candidato = -L/2 + L*rand;

        % Accetta se sufficientemente distante
        if i == 1 || all(abs(candidato - x(1:i-1)) >= DX)
            x(i) = candidato;
            break;
        end

    end
end

% Se serve averli ordinati
x = sort(x);

end