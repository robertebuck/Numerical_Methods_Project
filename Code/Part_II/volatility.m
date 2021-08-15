function sigma = volatility(sigma_0,S,t)
% volatility - Returns the local volatility.
% For constant volatility use these (useful for testing)
% sigma_1 = 0;
% sigma_2 = 0;

% Otherwise use these
sigma_1 = 0.12;
sigma_2 = 0.6;
sigma = sigma_0*(1 + sigma_1*cos(2*pi*t))*(1+sigma_2*exp(-S/100));
