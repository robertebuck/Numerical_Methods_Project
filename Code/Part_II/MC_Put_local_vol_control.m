function [ price, variance, CPU ] = MC_Put_local_vol_control( S0, K, r,...
sigma, r_0, sigma_0, T, Npaths )
% MC_Put_local_vol_control - Uses Monte Carlo simulation to compute the 
% price of a put option with a local volatility model using control 
% variates as a variance reduction technique.

% OUTPUTS:
% price - price of put
% variance - variance of put from Monte Carlo pricing
% CPU - CPU time to run the function

% IMPUTS: 
% S0 - price of underlying at time 
% K - strike price of put
% T - time to expiry (in years)
% Npaths - number of Monte Carlo simulation paths
% r_0, sigma_0 - imputs for local volatility model, non constant volatility
% and interest rate across time

% Assuming that geometric brownian motion with constant interest rate and
% volatitliy is the control variate

% Start CPU timer
e=cputime;

% The time step will be one working day (260 working days/year)
Nsteps = 260*T;
dt = T/Nsteps;

% Simulate Npath paths, each with Nsteps time steps (or Nsteps+1 time points
% counting the initial condition).
S = zeros(Npaths,Nsteps+1);
S_const = zeros(Npaths,Nsteps+1);
epsilon=randn(Npaths,Nsteps);

% Set initial conditions.
S(:,1) = S0;
S_const(:,1) = S0;

% Setting up a time vector increasing at rate dt each step
t= linspace(0,T,260*T);

% known mean and variance of g=S(T)=ST
mean_ST = S0 * exp(r*T);
var_ST = mean_ST^2*(exp(sigma^2*T)-1);

% Computing paths of spot under local volatility model and constant r &
% sigma 
for n = 1:Nsteps
S(:,n+1) = S(:,n) .* ( 1 + rate(r_0, t(1,n))*dt+volatility(sigma_0,...
S(:,n),t(n))*sqrt(dt).*epsilon(:,n) );

S_const(:,n+1) = S_const(:,n).*(1 + r*dt + sigma*epsilon(:,n)*sqrt(dt));
end

% Discounted payoff 
fST = exp(-sum(rate(r_0, t(1:end))*dt)).*max(K-S(:,Nsteps+1),0);

% getting our c
cov_fST_ST = cov(fST,S_const(:,end));
c = cov_fST_ST(1,2)/var_ST;

% implimenting control variance estimator
fc = fST-c*(S_const(:,end)-mean_ST);

% computing price, variance and CPU time
price = mean(fc);
variance = var(fc);
CPU = cputime-e;


