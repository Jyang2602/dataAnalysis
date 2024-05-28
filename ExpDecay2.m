% Exponential Decay fit function
%tau in units of points of vector

function D = ExpDecay2(tau,x);
	D = exp((x)/tau); 