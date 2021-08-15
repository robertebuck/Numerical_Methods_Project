% Main file to produce outputs for questions asked in Part 2 of the
% assesment.

run Initalisation_B;

% % Calculate the local volatility put price via various montecarlo
% methods, the number of simulations required for a pricing error < 
% 0.05 and the CPU time required to ensure this pricing error occurs
[price_naive, price_antithetic, price_control, Npath_naive, ...
Npath_antithetic, Npath_control, CPU_naive, CPU_antithetic, CPU_control]...
= MC_Put_Pricing_locvol( Smin, Smax, K, r_0, sigma_0, T, err);

% Computing CPU time for constant volatility model without euler time
% stepping
[CPU_const_vol, Price_const_vol, Variance_const_vol]  = ...
MC_const_vol_Put_CPU(Smin, Smax, K, r_0, sigma_0, T, err);

% difference in CPU time for local volatility and constant volatility model
% without euler time stepping
CPU_diff = CPU_naive - CPU_const_vol;

% Computing CPU time for constant volatility model with euler time
% stepping
[CPU_const_vol_euler, Price_MC_min_euler, Variance_MC_min_euler] ...
= MC_const_vol_Put_Euler_CPU(Smin, Smax, K, r_0, sigma_0, T, err);

% difference in CPU time for local volatility and constant volatility model
% with euler time stepping

CPU_diff_euler = CPU_naive - CPU_const_vol_euler;

% Barrier put option prices and CPU times under various montecarlo methods
% with a barrier at 30 and pricing error of 0.05
[price_naive_b, price_antithetic_b, price_control_b,...
Npath_naive_b, Npath_antithetic_b, Npath_control_b,...
CPU_naive_b, CPU_antithetic_b, CPU_control_b] = MC_Put_Pricing_locvol_barrier...
( Smin, Smax, Sb, K, r_0, sigma_0, T, err );

% Computing the prices of a barrier put over a range of prices using a
% variety of barriers this is done with a number of paths to ensure a
% pricing error less than 0.05 and using antithetic varaince reduction
[ price_antithetic_brange, variance_antithetic_brange ] =...
MC_barrier_range_put_local_vol_antithetic( Smin, Smax, Sbmin,...
Sbmax, K, T, Npath_antithetic_b, r_0 , sigma_0 );

% Computing the delta of the barrier put with antithetic varaince 
% reduction using variance reduction. This is done with a sufficent number
% of paths to ensure a pricing error less than 0.05
[ deltas ] = MC_barrier_put_local_vol_antithetic_delta_Sbrange...
( Smin, Smax, Sbmin, Sbmax, K, T, Npath_antithetic_b, r_0 , sigma_0 );




