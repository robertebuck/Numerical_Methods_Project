function [ deltas ] = MC_barrier_put_local_vol_antithetic_delta_Sbrange...
( Smin, Smax, Sbmin, Sbmax, K, T, Npaths, r_0 , sigma_0 )
% MC_barrier_put_local_vol_antithetic_delta_Sbrange - Computes the delta
% for the barrier put with local volatility model using antithetic variance
% reduction. This is done over a range of barriers and is also plotted.

% OUTPUTS:
% deltas - matrix of deltas for various barriers

% IMPUTS:
% Smin,Smax - price range of spot
% Sb - Lower bound
% K - strike price of put
% T - time to expiry (in years)
% Npaths - number of Monte Carlo simulation paths
% r_0, sigma_0 - imputs for local volatility model, non constant volatility
% and interest rate across time

% Variation of 1 in underlying used
ds = 1;

% Computing range of Spot prices over which delta will be calculated, note
% starts at Smin+ds to prevent S_left_p or S_left_m from having a value
% of zero
L = length(Smin+ds:ds:Smax);

% Range of spot prices
S = Smin:Smax;

% Range of barrier prices
Sb=Sbmin:10:Sbmax;

% Setting up delta matrix
deltas=zeros(length(Sb),L);

% Computing deltas for each barrier
for i  = 1:length(Sb)
[ deltas(i,:) ] = MC_barrier_put_local_vol_antithetic_delta...
( Smin, Smax, Sb(i), K, T, Npaths, r_0 , sigma_0 );
end


% plot of delta of put under various different barrier
figure
for i = 1:length(Sb)
plot(S(2:end),deltas(i,:))  
% scatter(S(2:end),deltas(i,:))
hold on
end
xlabel("Spot price","Fontsize",14)
ylabel("Delta","Fontsize",14)
hold off;
% could not find a way to get the legend to change depending on the range
% of Sb
legend("Barrier = 0", "Barrier = 10", "Barrier = 20", "Barrier = 30", ...
"Barrier = 40", "Barrier = 50")

% Note legend hard coded
