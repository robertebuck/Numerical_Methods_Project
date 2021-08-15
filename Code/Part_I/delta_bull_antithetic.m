function [deltas, err_delta, max_err_delta] = delta_bull_antithetic(Smin,...
Smax, K1, K2, r, sigma, N, T)
% delta_bull_antithetic - Calculates the delta of a call bull spread using
% MC simulations and antithetic variance reduction. Produces plots of 
% Deltas estimated vs true deltas and error in Delta estimation.

% OUTPUTS:
% deltas - Delta estimation
% err_delta - Error in delta estimation

% IMPUTS:
% Smin, Smax - range of underlyin prices
% K1  - Strike price of call bought
% K2 - Strike price of call sold
% r  - Interest rate
% sigma - volatility
% T - time to the expiration
% N - Number of Monte Carlo samples
% delta - The option delta

% variation of 1 in underlying used to compute the delta
ds = 1;

% Simulating N normally distributed random variables
X = randn(N,1);

% Setting inital index value used to feed into delta estimation for each
% spot  price
index = 1;

% Computing range of Spot prices over which delta will be calculated, note
% starts at Smin+ds to prevent S_left_p_T or S_left_m_T from having a value
% of zero
L = length(Smin+ds:ds:Smax);

% Setting up delta matrix
deltas = zeros(1,L);

% Z_p and Z_M constant so declared outside of loop to improve computational
% efficency
Z_p = exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*X);
Z_m = exp((r-0.5*sigma^2)*T-sigma*sqrt(T)*X);

% Computing the deltas over the full range of spot prices
for S0 = Smin+ds:ds:Smax

% Computing the spot prices at time T
S_right_p_T = (S0+ds)*Z_p;
S_left_p_T = (S0-ds)*Z_p;
S_right_m_T = (S0+ds)*Z_m;
S_left_m_T = (S0-ds)*Z_m;

% Computing the discounted payoffs
fS_right_p_T = exp(-r*T)*(max(S_right_p_T-K1,0)-max(S_right_p_T-K2,0));
fS_left_p_T = exp(-r*T)*(max(S_left_p_T-K1,0)-max(S_left_p_T-K2,0));
fS_right_m_T = exp(-r*T)*(max(S_right_m_T-K1,0)-max(S_right_m_T-K2,0));
fS_left_m_T = exp(-r*T)*(max(S_left_m_T-K1,0)-max(S_left_m_T-K2,0));

% computing value of the discounted payoffs with positive or negative 
% deviation from the spot price
fS_right_T = (fS_right_p_T + fS_right_m_T)/2;
fS_left_T = (fS_left_p_T + fS_left_m_T)/2;

% Computing average value of payoff across all simulations with positive or
% negative deviation from spot
V_right = mean(fS_right_T);
V_left = mean(fS_left_T);

% Computing value of deltas
deltas(index)= (V_right - V_left)/(2*ds);

% increasing index to ensue in next loop that delta is imputed into next
% element in the deltas vector
index = index+1;
end

% setting up range of spot prices
Spot = Smin:Smax;

% Calculating the Black Scholes delta
delta_BS = blsdelta(Spot,K1,r,T,sigma) - blsdelta(Spot,K2,r,T,sigma);

% Calculating error in delta estimation
err_delta = deltas - delta_BS(1:end-1);

% Maximum error in delta estimation
max_err_delta = norm(err_delta,inf);

% Plot of Deltas estimated vs true deltas
figure
hold on 
plot(Spot(2:end), deltas, 'k*')
plot(Spot, delta_BS)
xlabel("Spot Price","Fontsize",14)
ylabel("Call Bull Spread Delta","Fontsize",14)
legend("antithetic delta", "true delta","Fontsize",14)
hold off

% Plot of error in Delta estimation
figure
plot(Spot(2:end), err_delta)
xlabel("Spot Price","Fontsize",14)
ylabel("Error in estimation of delta","Fontsize",14)