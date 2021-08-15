function r = rate(r_0,t)
% rate - gives interest rate as a function of time, i.e. a non constant
% interest rate across time
% Returns interest rate at time t
% For constant rate
% r_1 = 0;
% Otherwise
r_1 = 0.5;
r = r_0*exp(r_1*t);