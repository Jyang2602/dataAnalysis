function [out]  =  SMOOTHTRACE(trace, window)
% uses the mean within a sliding window to smooth
% vector: input vector
% window: number of points on each side of 0 thus smoothing uses +/- window
% Instead of looping through each point and getting the points around it,
% loop through the window, and add the whole trace shifted - and +
% "Pads" the extremes with the first or last data point
% DVB 03/28/13

len=length(trace);   
Vector=zeros(len+window*2,1);
start=window+1; 
Vector(start:start+len-1)=trace;
%PAD START AND END
Vector(1:window) = trace(1);
Vector(end-window:end) = trace(end);
Sum=zeros(len,1);
for i=1:window*2+1;
   Sum=Sum+Vector(i:i+len-1);
end
Sum=Sum./(window*2+1);
out=Sum';
