function plot_compensation_graph(time,f_uncomp,f_comp)

%=========================================================================
%function PLOT_COMPENSATION_GRAPH
%   Plots a graph comparing the uncompensated force signals and the 
%   compensated force signals after inertial compensation
%
%------
%Input
%------
%   time      (Nsamples x 1)     Vector of timestamps
%   f_uncomp  (Nsamples x 6)     Array of uncompensated force signals
%                                of the form: [Fx,Fy,Fz,Mx,My,Mz]
%   f_comp    (Nsamples x 6)     Array of the compensated force signals
%                                of the form: [Fx,Fy,Fz,Mx,My,Mz]
%-------
%Output
%-------
%   Automatically generates the plot
%========================================================================= 
    figure(1)
    titles={'F_x','F_y','F_z','M_x','M_y','M_z'};
    for i=1:6
        subplot(2,3,i)
        plot(time,f_uncomp(:,i),'k')
        hold on
        plot(time,f_comp(:,i),'r')
        xlim([31 33]);
            %Labels
                title(titles{i},'Fontweight','bold','Fontsize',14); 
                if i==1
                    ylabel('Force (N)','Fontweight','bold','Fontsize',12);
                end
                if i==4
                    ylabel('Moment (Nm)','Fontweight','bold','Fontsize',12);
                end
                if i==5
                    xlabel('Time (s)','Fontweight','bold','Fontsize',12);
                end
    end
end