function [price, variance, CPU] = MC_control_euro_call_bull(S0, K1, K2, r, sigma, T, N)
% MC_control_euro_call_bull - Price Euro call bull spread by the Monte 
% Carlo method with variance reduction using the control variates approach

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

% refering to steps in lecture notes:
t = cputime;

E_ST = S0*exp(r*T);
VAR_ST = (E_ST.^2)*(exp(sigma^2*T) - 1);

% Simulating random variables
X=randn(N,1);

% Spot & discounted payoff
ST = S0.*exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*X);
fST = exp(-r*T)*(max(ST-K1,0) - max(ST-K2,0));

% Setting up covariance matrix
COV = zeros(1,length(S0));
for i=1:length(S0)
COV_matrix = cov(fST(:,i),ST(:,i));
COV(i) = COV_matrix(2,1);
end

% Calculating fc
c = COV./VAR_ST;
fc = fST - c.*(ST - E_ST);

% Computing price of bull spread estimated using control variates
price = mean(fc);
variance = var(fc);
CPU = cputime-t;