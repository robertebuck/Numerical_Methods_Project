function [price, variance, CPU] = MC_antithetic_euro_call_bull(S0, K1, K2, r, sigma, T, N)
% MC_antithetic_EURO_CALL_bull - Price Euro call bull spread by Monte Carlo
% appraoch using antiithetic variance reduction

% OUTPUTS:
% price - price of the bull spread
% variance - volatility in estimation of price
% CPU - CPU time taken to calculate the price

% IMPUTS:
% S0 - Current stock price
% K1 - Strike price of call long
% K2 - Strike price of call short
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% N - Number of Monte Carlo samples

% Starting timer for CPU time
t = cputime;

% Generating random variables
X=randn(N,1);

% Computing spot prices
ST_p = S0.*exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*X);
ST_m = S0.*exp((r-0.5*sigma^2)*T-sigma*sqrt(T)*X);

% Computing the discounted payoffs
fST_p = exp(-r*T)*(max(ST_p-K1,0) - max(ST_p-K2,0));
fST_m = exp(-r*T)*(max(ST_m-K1,0) - max(ST_m-K2,0));


Z= (fST_p + fST_m)/2;

% Calculating prices and variances of the bull spread value
price = mean(Z);
variance = var(Z);
CPU = cputime-t;