function [CPU_MC, Price_MC_min, Variance_MC_min]  = MC_const_vol_Put_CPU...
(Smin, Smax, K, r, sigma, T, err)
% MC_const_vol_Put_CPU - computes the output of a constant volatility naive
% Monte Carlo approach to pricing a European put option with pricing error
% less than err.

% OUTPUTS:
% CPU_MC - CPU time required to compute the put price over the rage of
% spot prices from Smin to Smax with a sufficent number simulations to
% ensure a pricing error < "err"
% Price_MC_min - Price of the put option accross Smin to Smax with a
% pricing error < "err"
% Variance_MC_min - Variance of the put option accross Smin to Smax with a
% pricing error < "err"

% IMPUTS:
% Smin , Smax - determins range of spot prices
% K - Strike price of put
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% err - maximum pricing error (degree of accuracy)


% set up range of spot prices, N = 1000 used to be consistent with number
% of paths used in local vol models
S=Smin:Smax;
N=1000;

% Setting up price and variance matricies
price_MC = zeros(1,length(S));
volatility_MC = zeros(1,length(S));

% Computing range of volatilities over S
for i=1:length(S)
[price_MC(i), volatility_MC(i)] = MC_euro_put( S(i), K, r, sigma, T, N );
end

% Finding required N to ensure pricing error less than err (0.05), this
% will be N_required_MC
N_required_MC_range = ((1.96/err)^2)*volatility_MC;
N_required_MC = ceil(norm(N_required_MC_range,inf));

% Setting up price and variance matricies
Price_MC_min = zeros(1,length(S));
Variance_MC_min = zeros(1,length(S));

% Computing CPU time for constant Vol with simulaitons = N_required
e =cputime;
for i=1:length(S)
    [Price_MC_min(i), Variance_MC_min(i)] = MC_euro_put(S(i), K, r, sigma, T, N_required_MC);
end

CPU_MC = cputime-e;