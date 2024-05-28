function [slope, tstart, tend]  =  SLOPEX(trace,numpoints)
% SLOPE calculates maximum slope
% input a trace
% output slope, tstart and tend, which can be used for plotting
% note that if you give part of a trace as input, the tstart and tend
% will be in reference to the subtrace.


   if nargin==1
      numpoints = 10;        
   end      
   [shift dummy]= min(trace);
   trace = (trace - shift);			% get rid of negative values         
   len = length(trace);
   [epsp ttp] = max(trace);

   slope= 0;
   tstart = 0; tend = 0;
   for i =1:(ttp-numpoints)
      y1 = trace(i); y2 = trace(i+numpoints);

      fit = polyfit(i:i+numpoints,trace(i:i+numpoints),1);
      if ( fit(1) > slope);
	      slope=fit(1);
	      tstart = i; tend = i+numpoints;
      end;
   end;

    
      
  
   if (tstart ==0)
      tstart=1; tend = 1;
   end   
   
