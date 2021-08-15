function [price, variance, CPU] = MC_euro_put_euler(S0, K, r, sigma, T, N_paths)
% MC_euro_put_euler - Prices a European put option by the Monte Carlo with
% Euler time stepping i.e. generating the whole path for the underlying.

% OUTPUTS:
% price - The option price
% variance - variance
% CPU - CPU time needed to run the function

% S0 - Current underlying price
% K  - Strike price
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% price - The option price
% variance - variance

% start CPU timer
e = cputime;

% assumption of 260 days in a year
N_steps = T*260;
dt = T/N_steps;

% Simulate Npath paths, each with Nsteps time steps (or Nsteps+1 time points
% counting the initial condition).
S = zeros(N_paths, N_steps+1);
epsilon = randn(N_paths,N_steps);

% Setting the inital conditions
S(:,1)= S0;

% simulating the paths of the underlying
for i = 1:N_steps
    S(:,i+1) = S(:,i).*(1 + r*dt + sigma*epsilon(:,i)*sqrt(dt));
end

% Computing the doiscounted payoff
fST = exp(-r*T)*max(K-S(:,end),0);

% Computing the price, varaince and CPU time
price = mean(fST);
variance = var(fST);
CPU = cputime-e;