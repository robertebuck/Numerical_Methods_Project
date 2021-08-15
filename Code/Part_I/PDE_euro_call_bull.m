function [V,S] = PDE_euro_call_bull(K1, K2, T, r, sigma, Smin, Smax, N, J)

% EURO_CALL_PDE - Pricing of Euro bull Spread via PDE (heat equation). 

% OUTPUTS:
% V - price of the option
% S - grid of underlying prices

% IMPUTS:
% K1 - strike price of call purchased
% K2 - strike price of call sold
% T - Time to maturity
% r - interest rate
% sigma - volatility
% Smin, Smax - range of S
% N, J - number of grid points in time and S respectively


k = 2*r/sigma^2;
alpha = -0.5*(k-1);
beta  = -0.25*(k+1)^2;

xmin = log(Smin/K1);
xmax = log(Smax/K1);
tau_max = T*sigma^2*0.5;

% Initial condition for heat equation variable u
u0 = @(x) (max(exp(x)-1,0)-max(exp(x)-K2/K1,0))./exp(alpha*x);

% Boundary conditions on u. 
gmin = @(tau) 0;
gmax = @(tau) ((K2/K1-1)*exp(-2*r*tau/(sigma^2)))/exp(alpha*xmax+beta*tau);

% solve heat equation
[u,x,tau]=heat_CN(u0, gmin, gmax, tau_max, xmin, xmax, N, J);

% Transform back from (x,u) to (S,V)
S = K1*exp(x);
V = u(:,end)'*K1.*exp(alpha*x+beta*tau_max);

