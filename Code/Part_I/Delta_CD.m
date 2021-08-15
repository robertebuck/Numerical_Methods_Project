function [delta_CD, error, max_error] = Delta_CD(S, V, K1, K2, r, sigma, T)
% Delta_CD - Calculates the delta of the bull spread using a centred 
% difference approach adjusted for irregularities in the grid. In addition,
% produces a plot of the deltas predicted by the centred difference approach
% and those produced by the Back-Scholes function. Also produces a plot of 
% the error in the deltas produced.

% OUTPUTS:
% delta_CD - delta prediced by CD approach
% error - error in delta predicted (relative to BS prediction)
% max_error - maximum error in the delta estimated

% IMPUTS:
% V - price of the bull call Spread
% S - grid of underlying prices
% K1 - Strike of call purchased
% K2 - Strike of call purchased
% r  - interest rate
% sigma - volatility
% T - Time to expiration

% Setting up the vector of deltas
delta_CD=zeros(1,length(V)-2);

% computing the deltas via the centered differnce approach over a range of
% spots
for i = 1:length(V)-2
delta_CD(i)=(V(i+2)-V(i))/(S(i+2) - S(i));
end

% Calculating the Black Scholes delta
delta_BS = blsdelta(S,K1,r,T,sigma) - blsdelta(S,K2,r,T,sigma);

% Calculating error in delta estimate
error = delta_CD - delta_BS(2:end-1);

% calculating the maximum error in the estimation
max_error = norm(error,inf);

% Plot of Delta predicted by CD and Black scholes Delta
figure
hold on
plot(S(2:end-1),delta_CD, 'k*')
plot(S(2:end-1),delta_BS(2:end-1))
hold off
xlabel("Spot Price","Fontsize",14)
ylabel("Call Bull Spread Delta","Fontsize",14)
legend("CD Delta","BS Delta","Fontsize",14)

% Plot of error in delta predicted by CD
figure
plot(S(2:end-1),error)
xlabel("Spot Price","Fontsize",14)
ylabel("Error in estimation of delta","Fontsize",14)
legend("centered difference","Fontsize",14)