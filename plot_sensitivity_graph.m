function plot_sensitivity_graph(time,torque_normal, torque_uncomp, torque_comp)

%=========================================================================
%function PLOT_SENSITIVITY_GRAPH
%    Generates graphs of the hip, knee, and ankle for the
%    normal,+uncompensated, and +compensated cases as calculated from
%    the sensitivity_analysis.m function
%
%------
%Input
%------
% time          (Nsamples x 1)   Vector of timestamps
% torque_normal (Nsamples x 3)   Array of the hip, knee, and ankle torques
%                                for the unaltered case
% torque_uncomp (Nsamples x 3)   Array of the hip, knee, and ankle torques
%                                for normal walking data + uncompensated
%                                forces (Fx, Fy, -Mx)
% torque_comp   (Nsamples x 3)   Array of the hip, knee, and ankle torques
%                                for normal walking data + compensated
%                                forces (Fx, Fy, -Mx)
% 
%-------
%Output
%-------
%    Automatically generates the plot
%========================================================================= 
    figure(2)
    c={'Hip Flexion','Knee Flexion','Ankle Plantarflexion'};
    for i=1:3
        subplot(1,3,i)
        hold on
        plot(time,torque_normal(:,i),'k--','linewidth',1.5)
        plot(time,torque_uncomp(:,i),'r')
        plot(time,torque_comp(:,i),'b')
        title(c{i},'Fontweight','bold','fontsize',14);
        xlim([1 3])
        %Axis Labels
            if i==1
                ylabel('Moment (Nm)','fontweight','bold');
            end
            if i==2
                xlabel('Time (s)','fontweight','bold');
            end   
    end
end
