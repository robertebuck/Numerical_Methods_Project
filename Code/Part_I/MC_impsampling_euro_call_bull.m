function [price, variance, CPU] = MC_impsampling_euro_call_bull(S0, K1, K2, r, sigma, T, N)
% MC_impsampling_euro_call_bull - Price Euro call bull spread by the Monte
% Carlo method with variance reduction using the important sampling 
% approach.

% OUTPUTS:
% price - price of the bull spread
% variance - volatility in estimation of price
% CPU - CPU time taken to calculate the price

% S0 - Current stock price
% K1 - Strike price of call long
% K2 - Strike price of call short
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% N - Number of Monte Carlo samples

% Starting CPU timer
t = cputime;

% Computing important sampling range
y0 = normcdf((log(K1./S0)-(r-1/2*sigma^2)*T)/(sigma*sqrt(T)));
Y= y0 + (1-y0).*rand(N,1);

% Generating random variables
X=norminv(Y);

% Setting up spot & discounted payoff at maturity
ST = S0.*exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*X);
fST = (1-y0)*exp(-r*T).*((ST-K1) - max(ST-K2,0));

% correct for case of isnan output in FST
fST(isnan(fST))=0; 

% Computing price of bull spread and variance in estimation
price = mean(fST);
variance = var(fST);
CPU = cputime-t;