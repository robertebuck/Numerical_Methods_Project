function [price, variance, CPU] = MC_euro_call_bull(S0, K1, K2, r, sigma, T, N)
% MC_euro_call_bull - Price Euro call bull spread by naive Monte Carlo 
% approach

% OUTPUTS:
% price - The bull spread price
% variance - variance
% CPU - The CPU time elapsed to run the function

% IMPUTS:
% S0 - Current stock price
% K1 - Strike price of call long
% K2 - Strike price of call short
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% N - Number of Monte Carlo samples

t = cputime;

% Generating random variables
X=randn(N,1);

% Computing final spot price
ST = S0.*exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*X);

% Computing discounted payoff
fST = exp(-r*T)*(max(ST-K1,0)-max(ST-K2,0));

% Computing price of bull spread and variance
price = mean(fST);
variance = var(fST);
CPU = cputime-t;