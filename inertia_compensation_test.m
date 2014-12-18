%======================================================================
%SCRIPT inertia_compensation_test.m
%   1) Loads data files containing random treadmill movements
%   2) Filters marker, force plate, and acceleration signals
%   3) Adds a time delay to the force and acceleration signals
%   4) Passes the acceleration and the pitch moment into the
%      compensation.m function to reduce the inertial errors
%   5) Produces plots comparing the uncompensated and compensated force
%      signals at the desired frequency (FP1 only)
%   7) Produces a plot of the RMS before and after compensation (Fxyz,Mxyz)
%      as a function of the range of cutoff frequencies (only if the range
%      is greater than one), (FP1 only)
%   8) Displays data table of the RMS before and after compensation and
%      the percent difference (FP1 only)
%======================================================================

clc
clear all
close all
display('Starting Computation...')

%=======================================================================
%PART 1: White Noise Trials, Sensitivity Analysis, Cutoff Frequency
%=======================================================================

%-----------------------------------------------------------------------
%Loading Data
%-----------------------------------------------------------------------
    display('Loading Data Files...')
    file_cal='Trial1.txt';
    file_val='Trial2.txt';
    data_cal=importdata(['Data' filesep file_cal]);
    data_val=importdata(['Data' filesep file_val]);
    %Parsing Data
        [data_cal]=data_parser(data_cal);
        [data_val]=data_parser(data_val);
%-----------------------------------------------------------------------
%Filtering, Compensating, Coordinate Transformation
%-----------------------------------------------------------------------
    %Set Range of Cutoff Frequencies
        frequencies=6;
        desired_frequency=6;
    %Preallocating Statistics Table
        statistics_table=zeros(length(frequencies),5);
    %Begin Compensation
        for i=1:length(frequencies)
            %Filtering
                fprintf('Estimating Model and Compensating at %d Hz...\n', frequencies(i))
                [num,den]=butter(2,frequencies(i)/(100/2));
                data_filt_cal=filter(num,den,data_cal(:,2:end));
                data_filt_val=filter(num,den,data_val(:,2:end));
            %Clipping
                data_filt_cal=[data_cal(100:end-100,1) data_filt_cal(100:end-100,:)];
                data_filt_val=[data_val(100:end-100,1) data_filt_val(100:end-100,:)];
            %---------------------------------------------------------
            %Adding Signal Delay
            %---------------------------------------------------------
                f_delay=0.0071;                
                a_delay=0.01; 
                [t_cal,m_cal,f_cal,a_cal]=add_delay(data_filt_cal,f_delay,a_delay);
                [t_val,m_val,f_val,a_val]=add_delay(data_filt_val,f_delay,a_delay);
            %---------------------------------------------------------   
            %Compensating and Coordinate Transformation
            %---------------------------------------------------------
                [compensated_forces]=compensation(f_cal,a_cal,f_val,a_val); 
            %---------------------------------------------------------    
            %Plot Uncompensated and Compensated at Desired Frequency
            %---------------------------------------------------------
                if frequencies(i)==desired_frequency
                    plot_compensation_graph(t_val,f_val(:,7:12),compensated_forces(:,7:12))
                    %Saving
                        figname1='CompensationResults.eps';
                        fpat='Results';
                        saveas(gcf,[fpat,filesep,figname1],'epsc')
            %---------------------------------------------------------
            %Calculate Statistics
            %---------------------------------------------------------
                statistics_table=calculate_statistics(frequencies(i),f_val(:,7:12),compensated_forces(:,7:12),desired_frequency);
                end
        end
display('Computation Completed.')