% Exponential Decay fit function
%tau in units of points of vector

function D = ExpDecay(beta,x);
   tau=beta(2);
   y0=beta(1);
   asym=beta(3);
	D = (y0-asym)*exp((x)/tau)+asym; 