%% ===============================================
%      MONTE CARLO LOCALIZATION ERROR TEST
% ===============================================

close all;
clear all;
clc;

f0 = 300e9;              
fc = 10e4;               

c0 = 3e8;                
k0 = 2*pi*f0/c0;         

lambda = c0/f0;

L = 60*lambda;             % Field length

do = 20 * lambda; 

% Sampling
N0 = round(L*fc);

if mod(N0,2)==0
    N = N0 + 1;
else
    N = N0;
end

Nmc = 1000;

% Storage of all localization errors
errors = [];


% Resolution of the imaging system
sigma2 = 5*lambda^2;
gamma = 3; % regularization parameter
resolution = pi*sqrt(sigma2)/(sqrt(2)*gamma*lambda);


% Minimum target separation
minDistance = 2*resolution;


%% ===============================================
%              MONTE CARLO LOOP
% ===============================================

for imc = 1:Nmc

    %% Generate targets

    rng('shuffle');

    numTargets = 3;
    xPos = randPosGen(numTargets,L/lambda,minDistance);


    %% Reconstruction

    [x,R] = reconstructionRecovery(xPos, f0, L, do, N);


    x = x(:);
    R = R(:);


    % Normalize reconstruction

    R = R/max(R);



    %% Peak detection (NO THRESHOLD)

    [~,xPeak] = findpeaks(R,x/lambda);



    %% Peak-target association

    xPeakAvailable = xPeak;

    xDetected = nan(size(xPos));


    for it = 1:length(xPos)


        % No peaks available

        if isempty(xPeakAvailable)
            break
        end


        % Closest peak

        [distance,idx] = min(abs(xPeakAvailable-xPos(it)));


        % Accept only if compatible with system resolution

        if distance <= resolution

            xDetected(it) = xPeakAvailable(idx);

            % Remove selected peak

            xPeakAvailable(idx) = [];

        end

    end



    %% Localization error

    idxValid = ~isnan(xDetected);


    if any(idxValid)

        newErrors = xDetected(idxValid)-xPos(idxValid);

        errors = [errors(:); newErrors(:)];

    end


    fprintf('MC iteration %d/%d | errors collected: %d | std = %.4f lambda\n',...
    imc, Nmc, length(errors), std(errors));

end



%% ===============================================
%      LOCALIZATION STATISTICS
% ===============================================

meanError = mean(errors);

stdError = std(errors);


fprintf('\n');
fprintf('Number of localization errors = %d\n',length(errors));
fprintf('Mean localization error       = %.5f lambda\n',meanError);
fprintf('Std localization error        = %.5f lambda\n',stdError);