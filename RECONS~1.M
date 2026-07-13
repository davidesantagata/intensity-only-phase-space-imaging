function [x, object] = reconstructionRecovery(xPosInput, f0, L, do, N)

%% ===============================================
%             PARAMETER INITIALIZATION
% ===============================================

c0 = 3e8;              % Speed of light [m/s]
k0 = 2 * pi * f0 / c0; % Propagation constant

lambda = c0/f0;


%% VARIANCE BEAM AND AXIS

sigma2 = 5 * lambda^2;

x = linspace(-L/2, L/2, N);
y = linspace(-L/2, L/2, N);


%% ========================================================================
%  TARGET POSITION
%  Define the target position along the x-axis
% ========================================================================

tau  = ones(size(xPosInput));                  % Target scattering coefficient
xRel = xPosInput;           % Target coordinates normalized by lambda
xPos = xRel * lambda;           % Target coordinates [m]

%% ========================================================================
%  ASPECT ANGLE
%  Define the observation angular range
% ========================================================================

denTheta = 10;                  % Denominator used to compute the maximum angle
thetaMax = pi / denTheta;       % Maximum observation angle [rad]

theta_i = pi/3;

%% ========================================================================
%  ANGULAR SAMPLING
%  Generate uniformly spaced observation angles
% ========================================================================

Ntheta = 101;                                   % Number of angular samples
theta = single(linspace(-thetaMax, ...
    thetaMax, ...
    Ntheta));              % Observation angles [rad]

%% ===============================================
%               SYSTEM FORWARD
% ===============================================

Output = systemForward(x, y, xPos, tau, sigma2, Ntheta, thetaMax, k0, do, theta_i, 'full');

%% ===============================================
%                  NOISE
% ===============================================
noiseChoice = 1;
SNRdB = 20;

if noiseChoice
    Measure = awgn(Output, SNRdB, 'measured');

    SNR_eff = snr(Output, Measure - Output);
    fprintf('SNR effettivo = %.2f dB\n', SNR_eff);
else
    Measure = Output;
    fprintf('Rumore disattivato (SNR = ∞) %.2f\n');
end

Mark = abs(Measure).^2; % Mark's Spectrum

%% ========================================================================
%  Marginalization over k-space
%  k = k0*sin(theta), including Jacobian correction
% ========================================================================

J = k0 * abs(cos(theta));      % Jacobian |dk/dtheta|

% Apply change of variables: d k = J d theta
Mark_weighted = Mark .* J(:);

% Marginal over k
Marginal_x = trapz(theta, Mark_weighted, 1);

%% ============================ INVERSION =============================== % 

gamma = 3;
R = windowingInversion(sigma2, gamma, Marginal_x, x, L, N);


%% Normalizzazione
R_norm  = abs(R)  / max(abs(R));

object = R_norm;

end