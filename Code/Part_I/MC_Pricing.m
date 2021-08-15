function [Price_MC_naive, Price_MC_antithetic, Price_MC_control,...
Price_MC_impsampling, N_max_naive, N_max_antithetic, N_max_control,...
N_max_impsampling, CPU_naive, CPU_antithetic, CPU_control,...
CPU_impsampling] = MC_Pricing(K1, K2, T, r, sigma, Smin, Smax, err)

% MC_Pricing - prices a bull spread using Monte Carlo simulations and various
% variance reduction techniques. In addition produces graphs of the
% required number of simulations to ensure a pricing error less than £0.05
% for each approach. Also plots the solution to the bull spread for this
% given pricing error for each Monte Carlo method.

% NOTE: This approach does not use path recycling when computing the bull 
% spread price for each spot price.

% OUTPUTS:
% Price_MC_naive - price of bull spread from MC simulations with no
% variance reduction
% Price_MC_antithetic - price of bull spread from MC simulations with
% antithetic variance reduction
% Price_MC_control - price of bull spread from MC simulations with control
% variance reduction
% Price_MC_impsampling - price of bull spread from MC simulations with
% important sampling
% N_max_naive - Number of simulations required to achieve an pricing error
% less than "err" for MC pricing approach with no variance reduction
% N_max_antithetic - Number of simulations required to achieve an pricing 
% error less than "err" for MC pricing approach with antithetic variance 
% reduction
% N_max_control - Number of simulations required to achieve an pricing 
% error less than "err" for MC pricing approach with control variance 
% reduction
% N_max_impsampling - Number of simulations required to achieve an pricing 
% error less than "err" for MC pricing approach with important sampling
% CPU_naive - CPU time required to compute the montecarlo pricing without
% varince reduction with N_max_naive simulations
% CPU_antithetic - CPU time required to compute the montecarlo pricing 
% with antithetic varince reduction with N_max_antithetic simulations
% CPU_control - CPU time required to compute the montecarlo pricing 
% with control varince reduction with N_max_control simulations
% CPU_impsampling - CPU time required to compute the montecarlo pricing 
% with important sampling with N_max_impsampling simulations

% IMPUTS:
% K1 - strike price of call purchased
% K2 - strike price of call sold
% T - Time to maturity
% r - interest rate
% sigma - volatility
% Smin, Smax - range of S
% N, J - number of grid points in time and S respectively
% err - degree of accuracy of solution required

% setting up vector with range of spot prices
S = Smin:Smax;

% setting inital values of N used to compute N_min
N=1000;

%%%%%%%%%%%%%%%%%%%  NAIVE   %%%%%%%%%%%%%%%%%

% Sample size needed MC Naive

% setting up price and variance matrix
Price_MC_naive=zeros(1,length(S));
Variance_MC_naive=zeros(1,length(S));

% Calculating variance used to estimate number of simulations required to 
% ensure minimum pricing error
for i=1:length(S)
[Price_MC_naive(i), Variance_MC_naive(i)] = MC_euro_call_bull(S(i), K1,...
K2, r, sigma, T, N);
end

% Calculating number of simulations required to ensure minimum pricing
% error
N_required_naive = ((1.96/err)^2)*Variance_MC_naive;
N_max_naive = ceil(norm(N_required_naive,inf));

% Setting up CPU matrix
CPU_naive_min=zeros(1,length(S));

% Calculating price of bull spread with N required to ensure pricing error
% < "err" (0.05)
for i=1:length(S)
[Price_MC_naive(i), Variance_MC_naive(i), CPU_naive_min(i)] =...
MC_euro_call_bull(S(i), K1, K2, r, sigma, T, N_max_naive);
end

% CPU time to compute put price using naive MC method across all spot
% prices
CPU_naive = sum(CPU_naive_min);


%%%%%%%%%%%%%%%%%%%  Antithetic   %%%%%%%%%%%%%%%%%


% Setting up price and variance matrix
Price_MC_antithetic=zeros(1,length(S));
Variance_MC_antithetic=zeros(1,length(S));

% Calculating variance used to estimate number of paths required to ensure
% minimum pricing error
for i=1:length(S)
[Price_MC_antithetic(i), Variance_MC_antithetic(i)] = ...
MC_antithetic_euro_call_bull(S(i), K1, K2, r, sigma, T, N);
end

% Calculating number of simulations required to ensure minimum pricing 
% error
N_required_antithetic = ((1.96/err)^2)*Variance_MC_antithetic;
N_max_antithetic = ceil(norm(N_required_antithetic,inf));

% Setting up CPU matrix
CPU_antithetic_min=zeros(1,length(S));

% Calculating price of put with N required to ensure pricing error <
% "err" (0.05)
for i=1:length(S)
[Price_MC_antithetic(i), Variance_MC_antithetic(i), CPU_antithetic_min(i)]...
= MC_antithetic_euro_call_bull(S(i), K1, K2, r, sigma, T, N_max_antithetic);
end

% CPU time to compute put price using antithetic variance reduction across 
% all spot prices
CPU_antithetic = sum(CPU_antithetic_min);


%%%%%%%%%%%%%%%%%%%  Control  %%%%%%%%%%%%%%%%%


% setting up price and variance matrix
Price_MC_control=zeros(1,length(S));
Variance_MC_control=zeros(1,length(S));

% Calculating variance used to estimate number of paths required to ensure
% minimum pricing error
for i=1:length(S)
[Price_MC_control(i), Variance_MC_control(i)] =...
MC_control_euro_call_bull(S(i), K1, K2, r, sigma, T, N);
end

% Calculating number of simulations required to ensure minimum pricing error
N_required_control = ((1.96/err)^2)*Variance_MC_control;
N_max_control = ceil(norm(N_required_control,inf));

% Setting up CPU Matrix
CPU_control_min=zeros(1,length(S));

% Calculating price of put with N required to ensure pricing error <
% "err" (0.05)
for i=1:length(S)
[Price_MC_control(i), Variance_MC_control(i), CPU_control_min(i)] =...
MC_control_euro_call_bull(S(i), K1, K2, r, sigma, T, N_max_control);
end

% CPU time to compute put price using control variance reduction across 
% all spot prices
CPU_control = sum(CPU_control_min);


%%%%%%%%%%%%%%%%%%%  Importance Sampling  %%%%%%%%%%%%%%%%%

% setting up price and variance matrix
Price_MC_impsampling=zeros(1,length(S));
Variance_MC_impsampling=zeros(1,length(S));

% Calculating variance used to estimate number of paths required to ensure
% minimum pricing error
for i=1:length(S)
[Price_MC_impsampling(i), Variance_MC_impsampling(i)] =...
MC_impsampling_euro_call_bull(S(i), K1, K2, r, sigma, T, N);
end

% Calculating number of simulations required to ensure minimum pricing error
N_required_impsampling = ((1.96/err)^2)*Variance_MC_impsampling;
N_max_impsampling = ceil(norm(N_required_impsampling,inf));

% Setting up CPU Matrix
CPU_impsampling_min=zeros(1,length(S));

% Calculating price of put with Npaths required to ensure pricing error <
% "err" (0.05)
for i=1:length(S)
[Price_MC_impsampling(i), Variance_MC_impsampling(i), CPU_impsampling_min(i)] ...
= MC_impsampling_euro_call_bull(S(i), K1, K2, r, sigma, T, N_max_impsampling);
end

% CPU time to compute put price using control variance reduction across 
% all spot prices
CPU_impsampling = sum(CPU_impsampling_min);


%Price from Black Scholes

Price_BS = blsprice(S,K1,r,T,sigma) - blsprice(S,K2,r,T,sigma);

%Plot of required number of simulations
figure
hold on
plot(S,N_required_naive)
plot(S,N_required_control)
plot(S,N_required_antithetic)
plot(S,N_required_impsampling)
hold off
xlabel("Spot Prices","Fontsize",14)
ylabel("Number of simulations","Fontsize",14)
legend("Naive","Control","Antithetic","Impsampling","Fontsize",14)

%Plot of solutions to option price

% Note commented out as will produce the same result as when using
% recycling

% figure
% hold on
% plot(S,Price_MC_naive,'+b')
% plot(S,Price_MC_antithetic, '*r')
% plot(S,Price_MC_control, 'dg')
% plot(S,Price_MC_impsampling, 'cs')
% plot(S,Price_BS)
% hold off
% xlabel("Spot Prices","Fontsize",14)
% ylabel("Price of Bull Spread","Fontsize",14)
% legend(["Naive","Control","Antithetic","Impsampling", "Black-Scholes"],...
% "location", "southeast","Fontsize",14)

