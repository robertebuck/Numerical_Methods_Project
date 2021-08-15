function [ price, variance, CPU ] = MC_Put_local_vol_antithetic( ...
 S0, K, r_0, sigma_0, T, Npaths )
% Uses Monte Carlo simulation to compute the price of a put option with a
% local volatility model using antithetic variance reduction.

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
S_p = zeros(Npaths,Nsteps+1);
S_m = zeros(Npaths,Nsteps+1);
epsilon=randn(Npaths,Nsteps);

% Set initial condition
S_p(:,1) = S0;
S_m(:,1) = S0;

% Setting up a time vector increasing at rate dt each step
t= linspace(0,T,260*T);

% Computing paths of underlying
for n = 1:Nsteps
S_p(:,n+1) = S_p(:,n) .* ( 1 + rate(r_0, t(n))*dt+volatility...
(sigma_0,S_p(:,n),t(n))*sqrt(dt).*epsilon(:,n) );

S_m(:,n+1) = S_m(:,n) .* ( 1 + rate(r_0, t(n))*dt-volatility...
(sigma_0,S_m(:,n),t(n))*sqrt(dt).*epsilon(:,n) );
end

% Computing discounted payoffs
fS_p = exp(-sum(rate(r_0, t(1:end))*dt))*max(K-S_p(:,Nsteps+1),0);
fS_m = exp(-sum(rate(r_0, t(1:end))*dt))*max(K-S_m(:,Nsteps+1),0);

% Computing price, varaince and CPU time
price = mean((fS_p + fS_m)/2);
variance = var((fS_p + fS_m)/2);
CPU = cputime-e;

