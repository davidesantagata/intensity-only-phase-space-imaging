%% ========================================================================
%  SINGLE-FREQUENCY INTENSITY-ONLY TARGET LOCALIZATION
%  Phase-Space Deconvolution Framework
%
%  Code associated with:
%
%  "Single-Frequency Intensity-Only Target Localization using
%   Phase-Space Deconvolution"
%
%  Authors:
%       Davide Santagata
%       Prof. Gabriele Gradoni
%       Prof. Raffaele Solimene
%
% 
%
%  Description:
%       This script generates synthetic intensity-only measurements,
%       computes Mark's physical spectrum, performs the phase-space
%       marginalization, and reconstructs the target distribution using
%       two deconvolution approaches:
%
%           1) Window-based inversion
%           2) Wiener-based inversion
%
% ========================================================================


clear;
close all;
clc;


%% ========================================================================
%  PHYSICAL PARAMETERS
% ========================================================================

f0 = 300e9;                  % Operating frequency [Hz]

c0 = 3e8;                    % Speed of light [m/s]

lambda = c0/f0;              % Wavelength [m]

k0 = 2*pi/lambda;            % Wavenumber [rad/m]


fc = 1e5;                   % Spatial sampling density [1/lambda]

L = 60*lambda;               % Spatial observation domain length [m]


% Observation distance
do = 5e10*lambda;            


% Number of spatial samples
N = round(L*fc);

if mod(N,2)==0
    N = N + 1;
end



%% ========================================================================
%  BEAM PARAMETERS
% ========================================================================

sigma2 = 5*lambda^2;          % Gaussian beam variance


x = linspace(-L/2,L/2,N);

y = linspace(-L/2,L/2,N);



%% ========================================================================
%  TARGET CONFIGURATION
% ========================================================================

% Target scattering coefficients
tau = [1,1,1];


% Target positions normalized by wavelength
xTarget_lambda = [-3.29,3.29, 9];


% Target positions in meters
xTarget = xTarget_lambda*lambda;



%% ========================================================================
%  ANGULAR CONFIGURATION
% ========================================================================

% Maximum observation angle
thetaMax = pi/10;


% Illumination angle
theta_i = pi/3;


% Number of angular samples
Ntheta = 101;


% Observation angles
theta = single(linspace(-thetaMax,...
                         thetaMax,...
                         Ntheta));



%% ========================================================================
%  FORWARD MODEL
% ========================================================================

fprintf('Generating synthetic measurements...\n');


Output = systemForward(...
            x,...
            y,...
            xTarget,...
            tau,...
            sigma2,...
            Ntheta,...
            thetaMax,...
            k0,...
            do,...
            theta_i,...
            'full');



%% ========================================================================
%  NOISE GENERATION
% ========================================================================

addNoise = true;

SNRdB = 20;


if addNoise

    EField = awgn(Output,SNRdB,'measured');

    noise = EField-Output;

    SNR_eff = snr(Output,noise);

    fprintf('Effective SNR = %.2f dB\n',SNR_eff);

else

    EField = Output;

    noise = zeros(size(Output));

    fprintf('Noise disabled\n');

end



%% ========================================================================
%  MARK'S PHYSICAL SPECTRUM
% ========================================================================

% Intensity-only measurement
Mark = abs(EField).^2;



%% ========================================================================
%  VISUALIZATION OF INTENSITY MEASUREMENTS
% ========================================================================

figure;


imagesc(x/lambda,theta,Mark);

axis xy;
axis tight;


colormap turbo;

colorbar;


xlabel('$x/\lambda$',...
       'Interpreter','latex');

ylabel('$\theta$ [rad]',...
       'Interpreter','latex');


title('Intensity Measurements',...
      'Interpreter','latex');


set(gca,...
    'FontSize',14,...
    'LineWidth',1.2,...
    'TickLabelInterpreter','latex');


box on;



%% ========================================================================
%  PHASE-SPACE MARGINALIZATION
%
%  The transformation:
%
%          k = k_0 sin(theta)
%
%  is performed including the Jacobian correction:
%
%          |dk/dtheta| = k_0 |cos(theta)|
%
% ========================================================================


Jacobian = k0*abs(cos(theta));


% Change of variables from theta to k-space
Mark_weighted = Mark .* Jacobian(:);


% Marginalization over the spatial frequency variable
Mark_marginal = trapz(theta,...
                      Mark_weighted,...
                      1);



figure;

plot(x/lambda,...
     Mark_marginal,...
     'LineWidth',1.5);


xlabel('$x/\lambda$',...
       'Interpreter','latex');


title('Marginal m(x)');


grid on;



%% ========================================================================
%  RECONSTRUCTION
% ========================================================================


gamma = 3;


% ------------------------------------------------------------------------
% Window-based inversion
% ------------------------------------------------------------------------

R_window = windowingInversion(...
                 sigma2,...
                 gamma,...
                 Mark_marginal,...
                 x,...
                 L,...
                 N);



% ------------------------------------------------------------------------
% Wiener-based inversion
% ------------------------------------------------------------------------

noisePower = mean(abs(noise(:)).^2);

signalPower = mean(abs(Output(:)).^2);


R_wiener = WienerInversion(...
                 sigma2,...
                 Mark_marginal,...
                 1e-8,...
                 signalPower,...
                 noisePower,...
                 x,...
                 L,...
                 N);


%% ========================================================================
%  NORMALIZATION
% ========================================================================

R_window_norm = abs(R_window)./max(abs(R_window));

R_wiener_norm = abs(R_wiener)./max(abs(R_wiener));


%% ========================================================================
%  RECONSTRUCTION COMPARISON
% ========================================================================

figure;


subplot(1,2,1)

plot(x/lambda,...
     R_window_norm,...
     'LineWidth',1.6);

xlabel('$x/\lambda$',...
       'Interpreter','latex');

ylabel('Normalized amplitude');

title('Window-based inversion');

grid on;



subplot(1,2,2)

plot(x/lambda,...
     R_wiener_norm,...
     'LineWidth',1.6);

xlabel('$x/\lambda$',...
       'Interpreter','latex');

ylabel('Normalized amplitude');

title('Wiener-based inversion');

grid on;



sgtitle('Comparison between reconstruction methods');