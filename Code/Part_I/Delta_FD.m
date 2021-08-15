function [delta_FD, error, max_error] = Delta_FD(S, V, K1, K2, r, sigma, T)
% Delta_FD - Calculates the delta of the bull spread using a one-sided 
% difference approach (forward difference) adjusted for irregularities 
% in the grid. In addition, produces a plot of the deltas predicted by 
% the one-sided difference approach and those produced by the Back-Scholes
% function. Also produces a plot of the error in the deltas produced.

% OUTPUTS:
% delta_FD - delta prediced by FD approach
% error - error in delta predicted (relative to BS prediction)
% max_error - maximum error in our delta estimation

% IMPUTS
% V - price of the bull call Spread
% S - grid of underlying prices
% K1 - Strike of call purchased
% K2 - Strike of call purchased
% r  - interest rate
% sigma - volatility
% T - Time to expiration

% Calculating the delta using forward-difference approximation
delta_FD=zeros(1,length(V)-1);
for i = 1:length(V)-1
delta_FD(i)=(V(i+1)-V(i))/(S(i+1) - S(i));
end

% Calculating the Black Scholes delta
delta_BS = blsdelta(S,K1,r,T,sigma) - blsdelta(S,K2,r,T,sigma);

% Calculating error in delta estimate
error = delta_FD - delta_BS(1:end-1);

% calculating the maximum error in the estimation
max_error = norm(error,inf);

% Plot of Delta predicted by FD and Black scholes Delta
figure
hold on
plot(S(1:end-1),delta_FD, 'k*')
plot(S(1:end-1),delta_BS(1:end-1))
hold off
xlabel("Spot Price","Fontsize",14)
ylabel("Call Bull Spread Delta","Fontsize",14)
legend("FD Delta","BS Delta","Fontsize",14)
% note issue with values being skewed

% Plot of error in Delta_FD vs Spot
figure
plot(S(1:end-1),error)
xlabel("Spot Price","Fontsize",14)
ylabel("Error in estimation of delta","Fontsize",14)
legend("One sided difference","Fontsize",14)


