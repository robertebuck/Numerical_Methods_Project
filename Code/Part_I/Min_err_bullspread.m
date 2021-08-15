function [N_min_err, J_min_err, init_err] = Min_err_bullspread(K1, K2, T, r, sigma, Smin, Smax, err)

% Min_err_bullspread - determines the values of N & J to ensure that the 
% numeric solution to a bull spread solved via the heat equation is within
% a given margin of error.

% OUTPUTS:
% N_min_err - The number of grid points needed in time dimension to achieve
% the given degree of accuracy dictated by error
% J_min_err - The number of grid points needed in space dimension to achieve 
% the given degree of accuracy dictated by error
% init_err - error of the solution

% IMPUTS:
% Smin, Smax - range of S
% K1 - Strike of call purchased
% K2 - Strike of call purchased
% r  - interest rate
% sigma - volatility
% T - Time to expiration
% err - degree of accuracy of solution required

N=2;
J=2;
i=0;

% init_err value chosen to be infinity to enable loop to run initally
init_err = inf;

% looping until the error is sufficently low
while init_err > err
    i= i+1;
    [V_PDE , S_PDE] = PDE_euro_call_bull(K1, K2, T, r, sigma, Smin, Smax, N^i, J^i);
    V_BS = blsprice(S_PDE,K1,r,T,sigma) - blsprice(S_PDE,K2,r,T,sigma);
    init_err = norm((V_BS - V_PDE),inf);
end

% rasing both N & J to the same power as truncation error decreases O(2)
% for both
N_min_err=N^i; 
J_min_err=J^i;