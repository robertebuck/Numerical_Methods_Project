% Main file to produce outputs for questions asked in Part 1 of the
% assesment.

run Initalisation_A

% Computing N & J for min error and 
%error = 0.05;
[N, J, min_err] = Min_err_bullspread(K1, K2, T, r, sigma, Smin, Smax, error);


% calculating CPU time for given N and J and plot solution
[V_PDE, S_PDE, CPU_PDE] = PDE_euro_call_bull_CPU(K1, K2, T, r, sigma, Smin, Smax, N, J);


% Calulating the delta using finite-difference method and the maximum
% error of this delta
[delta_FD, ~, error_FD_max] = Delta_FD(S_PDE, V_PDE, K1, K2, r, sigma, T);

% Calculating the delta using centered-difference method and the maximum
% error of this delta
[delta_CD, error_CD, error_CD_max] = Delta_CD(S_PDE, V_PDE, K1, K2, r, sigma, T);

% Calculate the bull spread price via various montecarlo methods, the 
% number of simulations required for a pricing error < 0.05 and the
% CPU time required to ensure this pricing error occurs, all of which done
% using path recycling
[Price_MC_naive_r, Price_MC_antithetic_r, Price_MC_control_r, ...
Price_MC_impsampling_r, N_max_naive_r, N_max_antithetic_r, ...
N_max_control_r, N_max_impsampling_r, CPU_naive_r, CPU_antithetic_r,...
CPU_control_r, CPU_impsampling_r] = MC_Pricing_recycle(K1, K2, T, r, sigma,...
Smin, Smax, error);


% Calculate the bull spread price via various montecarlo methods, the 
% number of simulations required for a pricing error < 0.05 and the
% CPU time required to ensure this pricing error occurs, all of which done not
% using path recycling
[Price_MC_naive, Price_MC_antithetic, Price_MC_control,...
Price_MC_impsampling, N_max_naive, N_max_antithetic, N_max_control,...
N_max_impsampling, CPU_naive, CPU_antithetic, CPU_control,...
CPU_impsampling] = MC_Pricing(K1, K2, T, r, sigma, Smin, Smax, error);


% Computing the Delta using antithetic
% Number of simulations picked arbitrarily
N=1000;
[deltas, err_deltas, max_err_delta] = delta_bull_antithetic(Smin, Smax, ...
K1, K2, r, sigma, N, T);

