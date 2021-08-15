function [U, x, t] = heat_CN(u0, gmin, gmax, t_f, xmin, xmax, N, J)
% heat_CN - Solve heat equation d_t u = d_xx u by CN scheme with general 
% Dirichlet boundary conditions.

% OUTPUTS:
% U - the solution
% x, t - vectors of grid points

% IMPUTS:
% u0 - Initial condition (function handle)
% gmin, gmax - The boundary conditions (function handles)
% t_f - Final time
% xmin, xmax - the range of the 'x' variable
% N - the number of time steps
% J - the number of intervals in 'x' direction

h  = (xmax-xmin)/J;
dt = t_f/N;
nu = dt/h^2;

t = [0:dt:t_f];
x = [xmin:h:xmax];

% Set up tridiagonal matrix I-dtL. We do this by constructing the three
% diagonals of dtL. From these generate the diagonals of I-dtL. 
dtL_sup =  nu/2 * [0;      ones(J-1,1)];
dtL_diag = nu/2 * [0; -2 * ones(J-1,1); 0];
dtL_sub =  nu/2 * [        ones(J-1,1); 0];

I_dtL_sup = - dtL_sup  ;
I_dtL_diag = ones(J+1,1) - dtL_diag;
I_dtL_sub = - dtL_sub;

% Allocate solution matrix will all zeros. Allocate vector RHS that will 
% be the right-hand-side of a linear system of equations.
U = zeros(J+1, N+1);
RHS = zeros(J+1, 1);

% set initial condition
U(:,1) = u0(x);

% Main time stepping loop
for n=1:N

    % "Explicit" part of time step using FE. 
    RHS(  1) = gmin(t(n+1));
    RHS(2:J) = U(2:J,n) + nu/2*(U(1:J-1,n)-2*U(2:J,n)+U(3:J+1,n));
    RHS(J+1) = gmax(t(n+1));
    
    % using tridiag function
    U(:,n+1) = tridiag(I_dtL_sub, I_dtL_diag, I_dtL_sup, RHS);
    
end

end