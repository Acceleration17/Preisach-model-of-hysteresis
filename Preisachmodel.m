
global datainput;


% tStart = 0;                                     % start time
% tEnd = 5;                                      % end time
% stepSize = 0.01;                                % size between each element
% numEl = length(tStart : stepSize : tEnd);	% number of elements
% the equation
% t = linspace(tStart, tEnd, numEl)';	        % create evenly spaced number of elements over the interval [tStart, tEnd] on the x-axis 
% y = ((5*exp(-(log(5/3)/5)*(t - 5)) + 10*exp(-(log(2)/5)*t))/2 + ((5*exp(-(log(5/3)/5)*(t - 5)) - 10*exp(-(log(2)/5)*t))/2).*sign(t - 5)).*cos((2*pi/5)*t);

t = 0:0.01:5;  % time
n_t = length(t);
fs = 0.5;  % frequency of signal
signal = (sin(2*pi.*fs.*t)-1)*0.8+0.8;
fn = 10; % frequency of noise
noise_Amplitude = 0.2;
sine_noise = noise_Amplitude.*sin(2*pi.*fn.*t);


figure1=figure(1);

n=100;
a0=1;
regular=1;
mu=generateMu(n,a0,regular);

 datainput=signal+sine_noise;
 

fftable=zeros(1,1);
ftable=[];

for  ncount=2:501
uNew=datainput(ncount);
 
[ff,mu]=DiscretePreisach(ncount,datainput,mu,n);
 fftable=[fftable ff];
 
end

clearvars mu
mu=generateMu(n,a0,regular);
clearvars ncount


for ncount=2:501
   
    subplot(1,3,1);
   
   hold on
   
   plot(t(1:ncount),datainput(1:ncount),'r') ;
   yticks([-10 -5 0 3 5 10]);
   axis([0 5 -2 2]);
   %pause(0.05);
   
   
   
   %%Start of plot 2%%
   
   subplot(1,3,2);
    plot(mu(2,:),mu(1,:),'squarer','MarkerSize',14,'MarkerFaceColor',[1 0 0])
    axis([-a0 a0 -a0 a0]);
    hold on

    
   uNew=datainput(ncount);
    
    [f,mu]=DiscretePreisach(ncount,datainput,mu,n);
    %ftable=[ftable f];

    
    countOn=0;
    countOff=0;
    N=n*(n+1)/2;
    
    for i=1:N
        if mu(3,i)==1
            countOn=countOn+1;
            muOn(1,countOn)=mu(1,i);
            muOn(2,countOn)=mu(2,i);
        else
            countOff=countOff+1;
            muOff(1,countOff)=mu(1,i);
            muOff(2,countOff)=mu(2,i);
        end
    end
    

    subplot(1,3,2);
    if exist('muOn','var') %if any hysterons are 'up' or 'on,' plot them
        plot(muOn(2,:),muOn(1,:),'squareb','MarkerSize',14,'MarkerFaceColor',[0 0 1])
        axis([-a0 a0 -a0 a0]);
        %pause(0.05)
    end
     
    
    if exist('muOff','var') %if any hysterons are 'down' or 'off,' plot them
        plot(muOff(2,:),muOff(1,:),'squarer','MarkerSize',14,'MarkerFaceColor',[1 0 0])
        axis([-a0 a0 -a0 a0]);
        %pause(0.05)
    end
    

    clearvars muOn muOff
    
    
    
    
    
    %%Start of Plot 3%%
    N=n*(n+1)/2;
    subplot(1,3,3);

    
     h = plot(NaN,NaN); 
     
      hLine = line('XData',datainput(1), 'YData',fftable(1), 'Color','r', ...
    'Marker','o', 'MarkerSize',6, 'LineWidth',2);
      hTxt = text(datainput(1), fftable(1), sprintf('(%.3f,%.3f)',datainput(1),fftable(1)), ...
    'Color',[0.2 0.2 0.2], 'FontSize',8, ...
    'HorizontalAlignment','left', 'VerticalAlignment','top');

     axis([-a0 a0 -N N]); 
     
        pause(0.01)
        set(h, 'XData', datainput(1:ncount), 'YData', fftable(1:ncount));
         
        
     set(hLine, 'XData',datainput(ncount), 'YData',fftable(ncount)  ) 
    set(hTxt, 'Position',[datainput(ncount) fftable(ncount)], ...
        'String',sprintf('(%.3f,%.3f)',[datainput(ncount) fftable(ncount)]))        
    drawnow 
     
     
    xlabel('Input','FontSize',14)
    ylabel('Output','FontSize',14)
    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') + [0 .01 0])
    xlabh = get(gca,'YLabel');
    set(xlabh,'Position',get(xlabh,'Position') + [.05 0 0])

end




