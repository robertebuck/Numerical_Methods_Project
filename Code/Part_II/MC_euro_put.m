function [price, variance, CPU] = MC_euro_put(S0, K, r, sigma, T, N)
% MC_EURO_PUT - Price European put option by Monte Carlo approach

% OUTPUTS:
% price - The option price
% variance - variance
% CPU - CPU time required to run the function

% IMPUTS
% S0 - Current underlying price
% K  - Strike price
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% N - Number of Monte Carlo samples

% Start CPU timer
e = cputime;

% Generate random variables
X=randn(N,1);

% Compute spot prices at time T
ST = S0*exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*X);

% Compute discounted payoff
fST = exp(-r*T)*max(K-ST,0);

% Compute price, variance and CPU time
price = mean(fST);
variance = var(fST);
CPU = cputime-e;