function [ price, variance ] = MC_barrier_range_put_local_vol_antithetic...
( Smin, Smax, Sbmin, Sbmax, K, T, Npaths, r_0 , sigma_0 )
% MC_barrier_range_put_local_vol_antithetic - Computes the price of a 
% barrier put with a local volatility model for a range of spot prices 
% and a range of barrier prices. This will also produce a graph the price
% of these various put options with different barriers. Pricing is done
% using Monte Carlo simulations with antithetic variance reduction.

% OUTPUTS: 
% price = matrix of prices of put for a variety of barrier prices
% variance = variance in estimation of put
% CPU - CPU time taken to run the function

% IMPUTS:
% Smin, Smax - range of underlying prices
% Sbmin, Sbmax - range of barrier prices
% K - strike price of barrier put
% T - time to expiry (in years)
% Npaths - number of Monte Carlo simulation paths
% r_0, sigma_0 - imputs for local volatility model, non constant volatility
% and interest rate across time


% Setting up range of barriers and spot prices
Sb = Sbmin:10:Sbmax;
S = Smin:Smax;

% Setting up price and variance matricies
price = zeros(length(Sb),length(S));
variance = zeros(length(Sb),length(S));

% Computing prices and variance for put option with a variety of barrier
% prices
for i = 1:length(Sb)
    for j = 1:length(S)
    [ price(i,j), variance(i,j)] = MC_barrier_put_local_vol_antithetic...
    ( S(j), Sb(i), K, T, Npaths, r_0 , sigma_0) ;
    end
end

% plot of price of put under various different barrier
figure
symbols = {'o','d','x','+','*','--'};
for i = 1:length(Sb)
plot(S,price(i,:),symbols{i})
hold on
end
xlabel("Spot price","Fontsize",14)
ylabel("Put price","Fontsize",14)
hold off;
% could not find a way to get the legend to change depending on the range
% of Sb
legend("Barrier = 0", "Barrier = 10", "Barrier = 20", "Barrier = 30", ...
"Barrier = 40", "Barrier = 50","Fontsize",14)
