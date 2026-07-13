%% ===============================================
%              MONTE CARLO DETECTION TEST
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


% Resolution parameter
sigma2 = 5*lambda^2;
gamma = 3;
resolution = pi*sqrt(sigma2)/(sqrt(2)*gamma*lambda);


% Minimum target separation
minDistance = 2*resolution;


Nmc = 1000;          % Monte Carlo realizations

Nthreshold = 50;

thresholds = linspace(0,1,Nthreshold);


% Storage
PD_all = zeros(Nthreshold,Nmc);

FAR_all = zeros(Nthreshold,Nmc);



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



    %% Threshold sweep

    for ith = 1:Nthreshold


        threshold = thresholds(ith);


        % Peak detection

        [~,xPeak] = findpeaks(R,x/lambda,...
            'MinPeakHeight',threshold);



        % Evaluate detection

        [Ndet,~,Nfa] = evaluateDetection(...
            xPos,...
            xPeak,...
            resolution);



        % Metrics

        Ntarget = length(xPos);

        Npeak = length(xPeak);



        % Detection probability

        PD_all(ith,imc) = Ndet/Ntarget;



        % False alarm ratio

        if Npeak > 0

            FAR_all(ith,imc) = Nfa/Npeak;

        else

            FAR_all(ith,imc)=0;

        end


    end


    fprintf('MC iteration %d/%d\n',imc,Nmc)

end



%% ===============================================
%              AVERAGE RESULTS
% ===============================================

PD_mean = mean(PD_all,2);

FAR_mean = mean(FAR_all,2);



%% ===============================================
%              ROC CURVE
% ===============================================

figure

plot(FAR_mean,PD_mean,...
    'LineWidth',2)

xlabel('False Alarm Ratio')

ylabel('Detection Probability')

grid on

title('ROC curve')

%% ===============================================
%              METRIC PLOTS
% ===============================================


% Detection probability vs threshold

figure

plot(thresholds,PD_mean,...
    'LineWidth',2)

xlabel('Normalized threshold \eta')

ylabel('Detection Probability P_D')

grid on

xlim([0 1])
ylim([0 1])

title('Detection probability')



% False alarm ratio vs threshold

figure

plot(thresholds,FAR_mean,...
    'LineWidth',2)

xlabel('Normalized threshold \eta')

ylabel('False Alarm Ratio')

grid on

xlim([0 1])
ylim([0 1])

title('False alarm ratio')


%% SALVATAGGI

data = [thresholds(:) PD_mean(:)];
filename = sprintf('PD_4T_20dB_pi_10_constant.dat');
save(filename, 'data', '-ascii');

data = [thresholds(:) FAR_mean(:)];
filename = sprintf('FAR_4T_20dB_pi_10_constant.dat');
save(filename, 'data', '-ascii');