function FillSemPlot(x,y,stderrorx,stderrory,c)
%x is the values on the x axes.
%y are generally the means of a group.
%stderror x is generally the same as stderrory

hold on;
if size(x,1) > 1 && size(x,2) == 1                % If not given in row arrays
    x = x';
    y = y';    
    stderrorx = stderrorx';
    stdy = stdy';
end
fill([x+stderrorx, fliplr(x-stderrorx)],[y+stderrory, fliplr(y-stderrory)],c,'FaceAlpha',0.3,'EdgeColor','none');
% plot(x,y,'-','Color',c,'Linewidth',1.5,'Markersize',4);


