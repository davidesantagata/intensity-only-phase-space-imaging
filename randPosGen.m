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

        candidate = -L/2 + L*rand;

        % it is accepted if sufficiently distant
        if i == 1 || all(abs(candidate - x(1:i-1)) >= DX)
            x(i) = candidate;
            break;
        end

    end
end

x = sort(x);

end
