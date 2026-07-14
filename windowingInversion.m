function R = windowingInversion(sigma2, gamma, m, x, L, N)

etaMax = gamma*sqrt(2/sigma2);

a = exp(-x.^2/(2*sigma2));

eta = linspace(-etaMax, etaMax, N);
H = fourierTransform(x, m(:), 1, etaMax, N);
A = fourierTransform(x, abs(flip(a(:))).^2, 1, etaMax, N);

R = abs(fourierTransform(eta, H./A, -1, L/2, N)).';

end
