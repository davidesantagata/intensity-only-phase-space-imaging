function E = systemForward(x, y, xPos, tau, sigma2, Ntheta, thetaMaxRad, k, do, theta_i, mode)

x = single(x);
xPos = single(xPos);
k = single(k);

Nx = length(xPos);

dxdy = single(x(2)-x(1))*single(y(2)-y(1));

theta = single(linspace(-thetaMaxRad,thetaMaxRad,Ntheta));


% ==============================
% GREEN GENERATION
% ==============================

[Xn,Xm] = ndgrid(xPos,xPos);

Rnm = abs(Xn-Xm);

a = sqrt(dxdy^2/pi);

C0 = 1i*k^2/4;

Gnm = (2*pi*a/k) ...
    *besselj(1,k*a) ...
    *besselh(0,2,k*Rnm);


% self term 
G_diag = (2*pi*a/k) ...
    *besselj(0,k*Rnm) ...
    *besselh(1,2,k*a) ...
    -1j*4/k^2;


Gnm(Rnm==0)=G_diag(Rnm==0);



% ==============================
% INCIDENT FIELD
% ==============================

Ns = length(x);       % numero posizioni di scansione
E = zeros(Ntheta,Ns,'single');

% random phase
% phi = -pi + 2*pi*rand(1,length(x));

phi = 0; % constant phase is selected.

einc = exp(-(x).^2/(2*sigma2)) ...
    .* exp(-1i*cos(theta_i)*x) ...
    .* exp(1i*phi);


% ==============================
% TOTAL FIELD GENERATION AND PROPAGATION
% ==============================

I = eye(Nx,'single');

for is = 1:Ns

    xs = x(is);

    % ------------------------------
    % Campo incidente per xs
    % ------------------------------

    Einc = interp1(x, einc, xPos-xs, 'linear',0).';


    % ------------------------------
    % Campo totale (Foldy-Lax)
    % ------------------------------

    if strcmp(mode,'full')

        Etot = (I-C0*Gnm.*tau)\Einc;

    else

        Etot = Einc;

    end


    % ------------------------------
    % Operatore esterno mobile
    % ------------------------------

    [Theta,Xp] = ndgrid(theta,xPos);

    Re = sqrt((Xp-xs + do*sin(Theta)).^2 ...
        + (do*cos(Theta)).^2);


    Ae = C0*besselh(1,2,k*Re)*dxdy;


    % ------------------------------
    % Campo uscente
    % ------------------------------

    E(:,is)=Ae*(Etot.*tau(:));

end

end
