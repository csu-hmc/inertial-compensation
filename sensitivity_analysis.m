function sensitivity_analysis(uncompensated,compensated)

%=========================================================================
%function SENSITIVITY_ANALYSIS
%      1) Loads a data file containing walking data
%         ~see leg2d.m for more information regarding the required data
%          for 2D inverse dynamic calculation of hip, knee, and ankle
%          joint (angles, velocitities, torques, forces)
%      2) Adds uncompensated and compensated errors to the walking data
%         (Fx, Fy, and -Mx) 
%      3) Calculates joint torques for the hip, knee, and ankle using the
%         leg2d.m function for the normal, +uncompensated errors, and 
%         +compensated errors case
%      4) Automatically plots the graph between 1-3 seconds of walking data
%         for all three cases for the hip, knee, and ankle
%      5) Calculates the R^2 value (how closely the uncompensated and
%         uncompensated data fits the original) and displays the values
%         on the graph legends
%      
%
%------
%Input
%------
%   uncompensated       (Nsamples x 6)     Array of the uncompensated force
%                                          signals in the form:
%                                          [Fx Fy Fz Mx My Mz]
%   compensated         (Nsamples x 6)     Array of the compensated force
%                                          signals in the form:
%                                          [Fx Fy Fz Mx My Mz]
%-------
%Output
%-------
%    Automatically generates the plot of the hip, knee, and ankle for the
%    normal,+uncompensated, and +compensated cases using the 
%    plot_sensitivity_graph.m function
%=========================================================================

%-------------------------------------------------------------------------
%Uploading File and Declaring Variables
%-------------------------------------------------------------------------
    filename='WalkingData.txt';
    walk_data=importdata(['Data' filesep filename]);
    %Declaring Variables
        times=walk_data.data(:,1)-walk_data.data(1,1);
        mocapdata=walk_data.data(:,2:13);
        normal_force_data=walk_data.data(:,14:16)/60;
        samples=length(normal_force_data);
%-------------------------------------------------------------------------
%Adding Uncompensated and Compensated Errors to Walking Data
%-------------------------------------------------------------------------
    uncomp_force_data=normal_force_data+([uncompensated(1:samples,1) uncompensated(1:samples,2) -uncompensated(1:samples,4)]./60);
    comp_force_data=normal_force_data+([compensated(1:samples,1) compensated(1:samples,2) -compensated(1:samples,4)]./60);
%-------------------------------------------------------------------------
%Inverse Dynamics for Each Case
%-------------------------------------------------------------------------
    %Making leg2d.m Available to this Function
        path_to_this_file = mfilename('fullpath');
        [directory_of_this_file, ~, ~] = fileparts(path_to_this_file);
        addpath([directory_of_this_file filesep 'leg2d'])
    %Inverse Dynamics using leg2d.m
        options.freq = 6;
        [~, ~, m_normal, ~] = leg2d(times, mocapdata, normal_force_data, options);    % Normal Data
        [~, ~, m_uncomp, ~] = leg2d(times, mocapdata, uncomp_force_data, options);    %+Uncompensated Forces
        [~, ~, m_comp,   ~] = leg2d(times, mocapdata, comp_force_data,   options);    %+Compensated Forces
    %Plotting
        plot_sensitivity_graph(times,m_normal*60, m_uncomp*60, m_comp*60)
%-------------------------------------------------------------------------
%Statistics (R^2)
%-------------------------------------------------------------------------
    for i=1:3
        Ssres_uncomp=sum(((m_normal(:,i)*60-m_uncomp(:,i)*60).^2));
        Ssres_comp=sum(((m_normal(:,i)*60-m_comp(:,i)*60).^2));
        Sstotal=sum(((m_normal(:,i)*60-mean(m_normal(:,i))).^2));
        rsq_uncomp=abs(1-Ssres_uncomp/Sstotal);
        rsq_comp=abs(1-Ssres_comp/Sstotal);
        subplot(1,3,i)
            legend('Measured',sprintf('Uncomp (%2.2f%%)',rsq_uncomp*100),sprintf('Comp (%2.2f%%)',rsq_comp*100))
    end
end
    