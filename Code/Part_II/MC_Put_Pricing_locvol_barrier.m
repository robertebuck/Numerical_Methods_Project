function [price_naive_min, price_antithetic_min, price_control_min,...
Npath_required_naive, Npath_required_antithetic, Npath_required_control,...
CPU_naive, CPU_antithetic, CPU_control] = MC_Put_Pricing_locvol_barrier...
( Smin, Smax, Sb, K, r_0, sigma_0, T, err )
% MC_Put_Pricing_locvol_barrier - computes for Monte Carlo simulations of a
% barrier put with a local volatility model the number of paths required to
% ensure a pricing error of less than the input "err". The price of the
% put for this corresponding number of paths over a give price range (Smin
% to Smax) and the CPU time required to compute these prices. This is done
% for the naive Monte Carlo method and with antithetic and control variates.
% It will also produce a plot of the put prices for these various pricing 
% methods and a plot of the number of paths needed to be simulated to 
% ensure a pricing error less than "err".

% NOTE: THIS FUNCTION WILL TAKE A LONG TIME TO RUN

% OUTPUTS:
% Price_naive_min - The price of the put option over Smin to Smax using
% naive montecarlo approach with Npath set to ensure a pricing error <
% "err"
% price_antithetic_min - The price of the put option over Smin to Smax 
% using antithetic variance reduction with Npath set to ensure a pricing
% error < "err"
% price_control_min - The price of the put option over Smin to Smax 
% using control variance reduction with Npath set to ensure a pricing
% error < "err"
% Npath_required_naive - number of paths required for the naive montecarlo
% approach to ensure a pricing error < "err"
% Npath_required_antithetic - number of paths required for the antithetic 
% variance reduction approach to ensure a pricing error < "err"
% Npath_required_control - number of paths required for the control 
% variance reduction approach to ensure a pricing error < "err"
% CPU_naive - CPU time required to calculate the price of a put option over
% Smin to Smax using the naive montecarlo approach and Npaths such that the
% pricing error < "err"
% CPU_antithetic - CPU time required to calculate the price of a put option 
% over Smin to Smax using the antithetic varaince reduction approach and 
% Npaths such that the pricing error < "err"
% CPU_control - CPU time required to calculate the price of a put option 
% over Smin to Smax using the control varaince reduction approach and 
% Npaths such that the pricing error < "err"

% IMPUTS:
% Smin, Smax - range of S
% K - strike price of put
% r_0 - intital parameter for function rate
% sigma_0 - inital parameter for function volatility
% T - Time to maturity
% err - minimum  error required for pricing via MC (typically 0.05)


% setting inital number of paths and range of spot prices 
Npath = 1000;
S=Smin:Smax;

%%%%%%%%%%%%%%%%%%%  NAIVE   %%%%%%%%%%%%%%%%%

% Sample size needed MC Naive

% setting up price and variance matrix
price_naive=zeros(1,length(S));
volatility_naive=zeros(1,length(S));

% Calculating variance used to estimate number of paths required to ensure
% minimum pricing error
for i=1:length(S)
[price_naive(i), volatility_naive(i)] = MC_barrier_put_local_vol_naive...
( S(i), Sb, K, T, Npath, r_0 , sigma_0 );
end

% Calculating number of paths required to ensure minimum pricing error
Npath_required_naive_range = ((1.96/err)^2)*volatility_naive;
Npath_required_naive = ceil(norm(Npath_required_naive_range,inf));

% Calculating number of paths required to ensure minimum pricing error
price_naive_min=zeros(1,length(S));
volatility_naive_min=zeros(1,length(S));
CPU_naive_min=zeros(1,length(S));

% Calculating price of put with Npaths required to ensure pricing error <
% "err" (0.05)
for i=1:length(S)
[price_naive_min(i), volatility_naive_min(i), CPU_naive_min(i)]  ...
= MC_barrier_put_local_vol_naive( S(i), Sb, K, T, Npath_required_naive,...
r_0 , sigma_0 );
end

% CPU time to compute put price using naive MC method across all spot
% prices
CPU_naive = sum(CPU_naive_min(Sb:end));


%%%%%%%%%%%%  ANTITHETIC  %%%%%%%%%%%

% Sample size needed MC antithetic

% Setting up price and variance matrix
price_antithetic=zeros(1,length(S));
volatility_antithetic=zeros(1,length(S));

% Calculating variance used to estimate number of paths required to ensure
% minimum pricing error
for i=1:length(S)
[price_antithetic(i), volatility_antithetic(i)] = ...
MC_barrier_put_local_vol_antithetic( S(i), Sb, K, T, Npath, r_0 , sigma_0 );
end

% Calculating number of paths required to ensure minimum pricing error
Npath_required_antithetic_range = ((1.96/err)^2)*volatility_antithetic;
Npath_required_antithetic = ceil(norm(Npath_required_antithetic_range,inf));

%Setting up price, volatility and CPU matricies
price_antithetic_min=zeros(1,length(S));
volatility_antithetic_min=zeros(1,length(S));
CPU_antithetic_min=zeros(1,length(S));

% Calculating price of put with Npaths required to ensure pricing error <
% "err" (0.05)
for i=1:length(S)
[price_antithetic_min(i), volatility_antithetic_min(i), ...
CPU_antithetic_min(i)] = MC_barrier_put_local_vol_antithetic...
( S(i), Sb, K, T, Npath_required_antithetic, r_0 , sigma_0 );
end

% CPU time to compute put price using antithetic variance reduction across 
% all spot prices
CPU_antithetic = sum(CPU_antithetic_min(Sb:end));


%%%%%%%%%%%%  CONTROL  %%%%%%%%%%%

% Sample size needed MC control

% setting up price and variance matrix
price_control=zeros(1,length(S));
volatility_control=zeros(1,length(S));

% r & sigma set in this way for clarity i.e to show the constant interest
% rate and volatility used in the control variance is the same as r_0 and
% sigma_0 respectively
r= r_0;
sigma = sigma_0;

% Calculating variance used to estimate number of paths required to ensure
% minimum pricing error
for i=1:length(S)
[price_control(i), volatility_control(i)] = MC_barrier_put_local_vol_control...
( S(i), r, sigma, Sb, K, T, Npath, r_0 , sigma_0 );
end

% Calculating number of paths required to ensure minimum pricing error
Npath_required_control_range = ((1.96/err)^2)*volatility_control;
Npath_required_control = ceil(norm(Npath_required_control_range,inf));

%Setting up price, volatility and CPU matricies
price_control_min=zeros(1,length(S));
volatility_control_min=zeros(1,length(S));
CPU_control_min=zeros(1,length(S));

% Calculating price of put with Npaths required to ensure pricing error <
% "err" (0.05)
for i=1:length(S)
[price_control_min(i), volatility_control_min(i), ...
CPU_control_min(i)] = MC_barrier_put_local_vol_control...
( S(i), r, sigma, Sb, K, T, Npath_required_control, r_0 , sigma_0 );
end

% CPU time to compute put price using control variance reduction across 
% all spot prices
CPU_control = sum(CPU_control_min(Sb:end));


%%%%%% PLOTS %%%%%%

% Plot of put prices 
figure
hold on 
plot(S(Sb:end), price_naive_min(Sb:end),'k*')
plot(S(Sb:end), price_antithetic_min(Sb:end),'r*')
plot(S(Sb:end), price_control_min(Sb:end),'gd')
hold off
xlabel("Spot price","Fontsize",14)
ylabel("Put price","Fontsize",14)
legend("Naive","Antithetic","Control")


% Plot of number of paths needed
figure
hold on
plot(S(Sb:end), Npath_required_naive_range(Sb:end))
plot(S(Sb:end), Npath_required_antithetic_range(Sb:end))
plot(S(Sb:end), Npath_required_control_range(Sb:end))
xlabel("Spot price","Fontsize",14)
ylabel("Number of paths required","Fontsize",14)
legend("Naive","Antithetic","Control")