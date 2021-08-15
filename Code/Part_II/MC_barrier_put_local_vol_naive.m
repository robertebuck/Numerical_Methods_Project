function [ price, variance, CPU ] = MC_barrier_put_local_vol_naive...
( S0, Sb, K, T, Npaths, r_0 , sigma_0 )
% MC_barrier_put_local_vol_naive - Uses Monte Carlo simulation to compute
% the price of a barrier put option without any variance reduction.

% OUTPUTS:
% price - price of barrier put
% variance - variance of down and out call from Monte Carlo pricing
% S0 - price of underlying at time 0
% Sb - Lower bound
% K - strike price of barrier put
% T - time to expiry (in years)
% Npaths - number of Monte Carlo simulation paths

% Start CPU timer
e = cputime;

% The time step will be one working day (260 working days/year)
Nsteps = 260*T;
dt = T/Nsteps;

% Simulate Npath paths, each with Nsteps time steps (or Nsteps+1 time points
% counting the initial condition).
S = zeros(Npaths,Nsteps+1);
epsilon=randn(Npaths,Nsteps);

% Setting up a time vector increasing at rate dt each step
t= linspace(0,T,260*T);

% Set initial condition and time step by the Euler method.
S(:,1) = S0;

for n = 1:Nsteps
S(:,n+1) = S(:,n) .* ( 1 + rate(r_0, t(1,n))*dt+volatility(sigma_0,S(:,n)...
,t(n))*sqrt(dt).*epsilon(:,n) );
end

%compute discount payoff:
fs = exp(-sum(rate(0.05, t(1,1:end))*dt))*heaviside(min(S , [], 2)...
- Sb).*max(K - S(:,end),0);

% Computing the price, variance and CPU time for the put
price = mean(fs);
variance = var(fs);
CPU = cputime-e;

