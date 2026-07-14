function R = WienerInversion(sigma2, M, eps0, P_signal, P_noise, x, L, N)

etaMax = 20*sqrt(2/sigma2);

a = exp(-x.^2/(2*sigma2));

eta = linspace(-etaMax, etaMax, N);
H = fourierTransform(x, M(:), 1, etaMax, N);
A = fourierTransform(x, abs(flip(a(:))).^2, 1, etaMax, N);

eps = (P_noise/P_signal)*eps0; %10^-9

D = H.*conj(A)./(abs(A).^2+eps);

R = 1/(2*pi) * abs(fourierTransform(eta, D, -1, L/2, N)).';

end
