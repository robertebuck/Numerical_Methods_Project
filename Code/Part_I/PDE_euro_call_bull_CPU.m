function [V,S,CPU] = PDE_euro_call_bull_CPU(K1, K2, T, r, sigma, Smin, Smax, N, J)

% PDE_euro_call_bull_CPU - Calculates the CPU time taken to compute the PDE
% solution to the BS equation for a bull spread for a given N & J. Also
% produces a plot of the solution to the bull spread.

% OUTPUTS:
% V - price of the bull call spread
% S - grid of underlying prices
% CPU - CPU time taken to compute PDE solution

% K1 - strike price of call purchased
% K2 - strike price of call sold
% T - Time to maturity
% r - interest rate
% sigma - volatility
% Smin, Smax - range of S
% N, J - number of grid points in time and S respectively


e = cputime;

% loop run 100 times and average CPU time taken as too fast
for i = 1:100
    [V, S] = PDE_euro_call_bull(K1, K2, T, r, sigma, Smin, Smax, N, J);
end
CPU = (cputime-e)/100;

% computing BS Price
Price_BS = blsprice(S,K1,r,T,sigma) - blsprice(S,K2,r,T,sigma);

% Plot of solution
hold on 
plot(S, V, '+b')
plot(S, Price_BS)
hold off
xlabel("Spot price" ,"Fontsize",14)
ylabel("bull spread price","Fontsize",14)
legend(["Numeric Solution","True Solution"],'Location','southeast',"Fontsize",14)
