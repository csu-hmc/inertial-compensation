function plot_frequency_graphs(RMS_data,desired_frequency)

%=========================================================================
%function PLOT_FREQUENCY_GRAPHS
%      Plots a graph comparing the RMS of the uncompensated and compensated
%      forces (Fxyz) and moments (Mxyz) as a function of the cutoff 
%      frequency of the lowpass filter. A dashed line will appear between 
%      the uncompensated and compensated values at location of the 
%      desired cutoff frequency.
%
%------
%Input
%------
%    RMS_data  (Nfrequencies x 5)  Array of statistical data of the form:
%                                  [Cutoff frequency, RMS Fxyz Before, 
%                                   RMS Mxyz Before, RMS Fxyz After, 
%                                   RMS Mxyz After]
%    desired_frequency  (double)   The cutoff frequency of the 
%                                  most interest
%-------
%Output
%-------
%    Automatically generates the plot of the RMS before and after 
%    compensation (Fxyz,Mxyz) 
%=========================================================================
     figure(3)
     %--------------
     %Forces
     %--------------
        subplot(1,2,1)
        hold on
        plot(RMS_data(:,1),RMS_data(:,2),'b','Linewidth',2)
        plot(RMS_data(:,1),RMS_data(:,4),'r','Linewidth',2)
        xlabel('Cutoff Frequency (Hz)','fontweight','bold')
        ylabel('RMS Forces (N)','fontweight','bold')
        legend('Uncompensated','Compensated')
            %Dashed Line at the Desired Cutoff Frequency
                if find(RMS_data(:,1)==desired_frequency)~=0
                    location=find(RMS_data(:,1)==desired_frequency);
                    x1=[RMS_data(location,1),RMS_data(location,1)];
                    y1=[RMS_data(location,2) RMS_data(location,4)];
                    plot(x1,y1,'k--')
                    plot(x1(1), y1(1),'.k')
                    plot(x1(2), y1(2),'.k')
                end
     %--------------
     %Moments
     %--------------
        subplot(1,2,2)
        hold on
        plot(RMS_data(:,1),RMS_data(:,3),'b','Linewidth',2)
        plot(RMS_data(:,1),RMS_data(:,5),'r','Linewidth',2)
        xlabel('Cutoff Frequency (Hz)','fontweight','bold')
        ylabel('RMS Moments (Nm)','fontweight','bold')
        legend('Uncompensated','Compensated')
            %Dashed Line at the Desired Cutoff Frequency
                if find(RMS_data(:,1)==desired_frequency)~=0
                    location=find(RMS_data(:,1)==desired_frequency);
                    x1=[RMS_data(location,1),RMS_data(location,1)];
                    y1=[RMS_data(location,3) RMS_data(location,5)];
                    plot(x1,y1,'k--')
                    plot(x1(1), y1(1),'.k')
                    plot(x1(2), y1(2),'.k')
                end
end
