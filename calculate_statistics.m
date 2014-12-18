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
    per_diff=zeros(6,1);
%-------------------------------------
%Statistical Calculation
%-------------------------------------
    for i=1:6
        RMS_uncompensated(i,:)=sqrt(mean(uncompensated(:,i).^2));
        RMS_compensated(i,:)=sqrt(mean(compensated(:,i).^2));
        per_diff(i,:)=((RMS_uncompensated(i,:)-RMS_compensated(i,:))/RMS_uncompensated(i,:))*100;
        statistics_table=[RMS_uncompensated RMS_compensated per_diff];
    end
%--------------------------------------------------
%Display Results if Frequency is Desired Frequency
%--------------------------------------------------
    if frequency == desired_frequency
        %Generate Table
            fprintf('_____________________________________________________________\n')
            fprintf('               Fx     Fy       Fz      Mx      My       Mz                  \n')
            fprintf('_____________________________________________________________\n')
            fprintf('Before:      %2.2f  %2.2f    %2.2f     %2.2f   %2.2f    %2.2f       \n',statistics_table(:,1)')
            fprintf('After:       %2.2f  %2.2f    %2.2f      %2.2f     %2.2f    %2.2f       \n',statistics_table(:,2)')
            fprintf('Per. Diff:   %2.2f  %2.2f    %2.2f    %2.2f   %2.2f    %2.2f       \n',statistics_table(:,3)')
            fprintf('_____________________________________________________________\n\n')
    end
end