function [ price, variance, CPU ] = MC_Put_local_vol( S0, K, r_0, sigma_0, T, Npaths )
% MC_Put_local_vol - Uses Monte Carlo simulation to compute the price of a 
% put option with a local volatility model.

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

% start CPU timer
e = cputime;

% The time step will be one working day (260 working days/year)
Nsteps = 260*T;
dt = T/Nsteps;

% Simulate Npath paths, each with Nsteps time steps (or Nsteps+1 time points
% counting the initial condition).
S = zeros(Npaths,Nsteps+1);
epsilon=randn(Npaths,Nsteps);

% Set initial condition and time step by the Euler method.
S(:,1) = S0;

% Setting up a time vector increasing at rate dt each step
t= linspace(0,T,260*T);

% Computing the paths of the underlying
for n = 1:Nsteps
S(:,n+1) = S(:,n) .* ( 1 + rate(r_0, t(1,n))*dt+volatility(sigma_0,S(:,n)...
,t(n))*sqrt(dt).*epsilon(:,n) );
end

% computing discounted payoff
fs = exp(-sum(rate(r_0, t(1:end))*dt))*max(K-S(:,Nsteps+1),0);

% computing price, variance and CPU time
price = mean(fs);
variance = var(fs);
CPU = cputime-e;

