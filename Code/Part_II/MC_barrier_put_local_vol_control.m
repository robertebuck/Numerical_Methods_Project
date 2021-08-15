function [ price, variance, CPU ] = MC_barrier_put_local_vol_control...
( S0, r, sigma, Sb, K, T, Npaths, r_0 , sigma_0 )
% MC_barrier_put_local_vol_control - Uses Monte Carlo simulation to compute
% the price of a barrier put option with a local volatility model using
% control variates. The underlying price, that evolves according to
% geometric Brownian motion with drift with constant interest rate and 
% volatility, is used as the control variate.

% OUTPUTS: 
% price = price of put
% variance = variance in estimation of put
% CPU - CPU time taken to run the function

% IMPUTS:
% S0 - price of underlying at time 0
% Sb - Lower bound
% K - strike price of barrier put
% T - time to expiry (in years)
% Npaths - number of Monte Carlo simulation paths
% r_0, sigma_0 - imputs for local volatility model, non constant volatility
% and interest rate across time

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

% Set initial conditions 
S(:,1) = S0;
S_const(:,1) = S0;

% Setting up a time vector increasing at rate dt each step
t= linspace(0,T,260*T);

% known mean and variance of g=S(T)=ST
mean_ST = S0 * exp(r*T);
var_ST = mean_ST^2*(exp(sigma^2*T)-1);

% loop to compute the paths of the underlying prices
for n = 1:Nsteps
S(:,n+1) = S(:,n) .* ( 1 + rate(r_0, t(1,n))*dt+volatility(sigma_0,S(:,n)...
,t(n))*sqrt(dt).*epsilon(:,n) );

S_const(:,n+1) = S_const(:,n).*(1 + r*dt + sigma*epsilon(:,n)*sqrt(dt));
end

% Computing payoff
fST = exp(-sum(rate(r_0, t(1:end))*dt))*heaviside(min(S, [], 2) - Sb)...
.*max(K-S(:,Nsteps+1),0);

% getting our c
cov_fST_ST = cov(fST,S_const(:,end));
c = cov_fST_ST(1,2)/var_ST;

% implimenting control variance estimator
fc = fST-c*(S_const(:,end)-mean_ST);

% Computing the price, variance and CPU time for the put
price = mean(fc);
variance = var(fc);
CPU = cputime-e;



