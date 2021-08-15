function [ delta ] = MC_barrier_put_local_vol_antithetic_delta...
( Smin, Smax, Sb, K, T, Npaths, r_0 , sigma_0 )
% MC_barrier_put_local_vol_antithetic_delta - Computes the delta of a 
% barrier put with a local volatility model using antithetic variance
% reduction.

% OUTPUTS:
% Delta - delta estimation for put

% IMPUTS:
% Smin,Smax - price range of spot
% Sb - Lower bound
% K - strike price of barrier put
% T - time to expiry (in years)
% Npaths - number of Monte Carlo simulation paths
% r_0, sigma_0 - imputs for local volatility model, non constant volatility
% and interest rate across time

% variation of 1 in underlying used
ds = 1;

% Setting inital index value used to feed into delta estimation for each
% spot  price
index = 1;

% Computing range of Spot prices over which delta will be calculated, note
% starts at Smin+ds to prevent S_left_p or S_left_m from having a value
% of zero
L = length(Smin+ds:ds:Smax);

% Setting up delta matrix
delta = zeros(1,L);

% The time step will be one working day (260 working days/year)
Nsteps = 260*T;
dt = T/Nsteps;

% Setting up a time vector increasing at rate dt each step
t= linspace(0,T,260*T);

% Simulate Npath paths, each with Nsteps time steps (or Nsteps+1 time points
% counting the initial condition).
S_right_p = zeros(Npaths,Nsteps+1);
S_left_p = zeros(Npaths,Nsteps+1);
S_right_m = zeros(Npaths,Nsteps+1);
S_left_m = zeros(Npaths,Nsteps+1);
epsilon=randn(Npaths,Nsteps);

for S0 = Smin+ds:ds:Smax

% Set initial condition
S_right_p(:,1) = S0+ds;
S_left_p(:,1) = S0-ds;
S_right_m(:,1) = S0+ds;
S_left_m(:,1) = S0-ds;

% Compute the paths via euler time stepping
for n = 1:Nsteps
S_right_p(:,n+1) = S_right_p(:,n) .* ( 1 + rate(r_0, t(n))*dt+volatility...
(sigma_0,S_right_p(:,n),t(n))*sqrt(dt).*epsilon(:,n) );

S_left_p(:,n+1) = S_left_p(:,n) .* ( 1 + rate(r_0, t(n))*dt+volatility...
(sigma_0,S_left_p(:,n),t(n))*sqrt(dt).*epsilon(:,n) );

S_right_m(:,n+1) = S_right_m(:,n) .* ( 1 + rate(r_0, t(n))*dt-volatility...
(sigma_0,S_right_m(:,n),t(n))*sqrt(dt).*epsilon(:,n) );

S_left_m(:,n+1) = S_left_m(:,n) .* ( 1 + rate(r_0, t(n))*dt-volatility...
(sigma_0,S_left_m(:,n),t(n))*sqrt(dt).*epsilon(:,n) );
end

% Calculating discounted payoffs
fS_right_p = exp(-sum(rate(r_0, t(1:end))*dt))*heaviside(min(S_right_p ,...
[], 2) - Sb).*max(K-S_right_p(:,Nsteps+1),0);

fS_left_p = exp(-sum(rate(r_0, t(1:end))*dt))*heaviside(min(S_left_p ,... 
[], 2) - Sb).*max(K-S_left_p(:,Nsteps+1),0);

fS_right_m = exp(-sum(rate(r_0, t(1:end))*dt))*heaviside(min(S_right_m ,...
[], 2) - Sb).*max(K-S_right_m(:,Nsteps+1),0);

fS_left_m = exp(-sum(rate(r_0, t(1:end))*dt))*heaviside(min(S_left_m ,...
[], 2) - Sb).*max(K-S_left_m(:,Nsteps+1),0);

% computing value of payoff with positive or negative deviation from spot
fS_right_T = (fS_right_p + fS_right_m)/2;
fS_left_T = (fS_left_p + fS_left_m)/2;

% computing value of option given positive or negative deviation in spot
V_right = mean(fS_right_T);
V_left = mean(fS_left_T);

% compute delta
delta(index)= (V_right - V_left)/(2*ds);

% increasing index to ensue in next loop that delta is imputed into next
% element in the deltas vector
index = index+1;
end




