function statistics_table=calculate_statistics(frequency,uncompensated,compensated,desired_frequency)

%=========================================================================
%function CALCULATE_STATISTICS
%      1) Calculates the RMS before and after performing inertial
%         compensation for each signal (Fx,Fy,Fz,Mx,My,Mz)
%      2) Calculates the norm of the RMS before and after for force and 
%         moment signals (Fxyz, Mxyz)
%      3) Stores the current cutoff-frequency of the lowpass filter
%      4) If the current cutoff frequency is the desired cutoff frequency,
%         a table is automatically displayed that shows the RMS before and
%         after compensation (Fxyz,Mxyz) and the percent difference 
%
%-------
%Inputs
%-------
%   frequency           (double)             Current cutoff frequency of the
%                                          low-pass filter
%   uncompensated       (Nsamples x 6)     Array of the uncompensated force
%                                          signals in the form:
%                                          [Fx Fy Fz Mx My Mz]
%   compensated         (Nsamples x 6)     Array of the compensated force
%                                          signals in the form:
%                                          [Fx Fy Fz Mx My Mz]
%   desired_frequency   (double)             The cutoff frequency of interest
%--------
%Outputs
%--------
%   statistics_table (1 x 5)          Row of statistics in the form:
%                                     [frequency, Fxyz_uncompensated,
%                                     Mxyz_uncompensated, Fxyz_compensated,
%                                     Mxyz_uncompensated]
%   If the desired frequency is the same as the current frequency, a table
%   is automatically generated to display the statistics of the RMS before and
%   after compensation (Fxyz, Mxyz), and the percent difference 
%=========================================================================

%-------------------------------------
%Preallocate RMS Compensation Tables
%-------------------------------------
    RMS_uncompensated=zeros(6,1);
    RMS_compensated=zeros(6,1);
%-------------------------------------
%Statistical Calculation
%-------------------------------------
    for i=1:6
        RMS_uncompensated(i,:)=sqrt(mean(uncompensated(:,i).^2));
        RMS_compensated(i,:)=sqrt(mean(compensated(:,i).^2));
    end
    %Calculating Norm (Fxyz,Mxyz) and Creating Results Table
        F_uncomp=norm(RMS_uncompensated(1:3,:));
        M_uncomp=norm(RMS_uncompensated(4:6,:));
        F_comp=norm(RMS_compensated(1:3,:));
        M_comp=norm(RMS_compensated(4:6,:));   
        statistics_table=[frequency F_uncomp M_uncomp F_comp M_comp];
%--------------------------------------------------
%Display Results if Frequency is Desired Frequency
%--------------------------------------------------
    if frequency == desired_frequency
        F_diff=((F_uncomp-F_comp)/F_uncomp)*100;
        M_diff=((M_uncomp-M_comp)/M_uncomp)*100;
        results_table=[F_uncomp F_comp F_diff M_uncomp M_comp M_diff];
        %Generate Table
            fprintf('________________________________________________________\n')
            fprintf('        Fxyz                       Mxyz                 \n')
            fprintf('Before  After   %%Diff     Before   After    %%Diff      \n')
            fprintf('________________________________________________________\n')
            fprintf(' %2.2f  %2.2f    %2.2f     %2.2f   %2.2f     %2.2f       \n',results_table')
            fprintf('________________________________________________________\n\n')
    end
end