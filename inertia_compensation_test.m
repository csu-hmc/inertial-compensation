%======================================================================
%SCRIPT inertia_compensation_test.m
%   1) Loads data files containing random treadmill movements
%   2) Filters marker, force plate, and acceleration signals
%   3) Adds a time delay to the force and acceleration signals
%   4) Passes the acceleration and the pitch moment into the
%      compensation.m function to reduce the inertial errors
%   5) Performs a coordinate transformation using the Soderquist method
%      in the transformation.m function
%   6) Produces plots comparing the uncompensated and compensated force
%      signals at the desired frequency (FP1 only)
%   7) Calculates the 2D inverse kinematics from walking data.  Adds
%      uncompensated and compensated errors to the original walking data
%      and plots the hip, knee, and ankle torques for all conditions (FP1)
%   8) Produces a plot of the RMS before and after compensation (Fxyz,Mxyz)
%      as a function of the range of cutoff frequencies (only if the range
%      is greater than one), (FP1 only)
%   9) Displays data table of the RMS before and after compensation and
%      the percent difference (FP1 only)
%   10)Performs validation tests using 10 trials of 5 different movement
%      types.  Using a calibration trial from each movement type, the 
%      inertial artifacts from all other trials are compensated with the
%      coefficients determined from the calibration trial.  A table of the 
%      mean and standard deviation of RMS values are generated using 5 
%      different calibration matrices are generated and saved as an excel
%      sheet
%======================================================================

clc
clear
close all
display('Starting Computation...')

%=======================================================================
%PART 1: White Noise Trials, Sensitivity Analysis, Cutoff Frequency
%=======================================================================

%-----------------------------------------------------------------------
%Loading Data
%-----------------------------------------------------------------------
    display('Loading Data Files...')
    file_cal='RandomTrial1.txt';
    file_val='RandomTrial2.txt';
    data_cal=importdata(['Data' filesep file_cal]);
    data_val=importdata(['Data' filesep file_val]);
    %Parsing Data
        [data_cal]=data_parser(data_cal);
        [data_val]=data_parser(data_val);
%-----------------------------------------------------------------------
%Filtering, Compensating, Coordinate Transformation
%-----------------------------------------------------------------------
    %Set Range of Cutoff Frequencies
        frequencies=1:20;
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
                a_delay=0.0844; 
                [t_cal,m_cal,f_cal,a_cal]=add_delay(data_filt_cal,f_delay,a_delay);
                [t_val,m_val,f_val,a_val]=add_delay(data_filt_val,f_delay,a_delay);
            %---------------------------------------------------------   
            %Compensating and Coordinate Transformation
            %---------------------------------------------------------
                [compensated_forces]=compensation(f_cal,a_cal,f_val,a_val); 
                rotated_forces=transformation(m_val,compensated_forces);
            %---------------------------------------------------------    
            %Plot Uncompensated and Compensated at Desired Frequency
            %---------------------------------------------------------
                if frequencies(i)==desired_frequency
                    plot_compensation_graph(t_val,f_val(:,1:6),rotated_forces(:,1:6))
                    %Saving
                        figname1='CompensationResults.eps';
                        fpat='Results';
                        saveas(gcf,[fpat,filesep,figname1],'epsc')
            %---------------------------------------------------------
            %Sensitivity Analysis at Desired Frequency
            %---------------------------------------------------------
                    sensitivity_analysis(f_val,rotated_forces)
                        %Saving
                            figname2='SensitivityAnalysis.eps';
                            saveas(gcf,[fpat,filesep,figname2],'epsc')     
                end
            %---------------------------------------------------------
            %Calculate Statistics
            %---------------------------------------------------------
                statistics_table(i,:)=calculate_statistics(frequencies(i),f_val(:,1:6),compensated_forces(:,1:6),desired_frequency);
        end
%-----------------------------------------------------------------
%Plot Cutoff Frequency Graph
%-----------------------------------------------------------------
    if length(frequencies)>1
        plot_frequency_graphs(statistics_table,desired_frequency);
        %Saving
            figname3='CutoffFrequency.eps';
            fpat='Results';
            saveas(gcf,[fpat,filesep,figname3],'epsc')
    end
%========================================================================
%Part 2: Validation Tests
%========================================================================
    display('Starting Validation Tests...')
    %Making Calibration Files Available to Script
        path_to_this_file = mfilename('fullpath');
        [directory_of_this_file, ~, ~] = fileparts(path_to_this_file);
        addpath([directory_of_this_file filesep 'Data' filesep 'Validation-Tests' filesep 'Calibrations'])
    %Starting Validation Test Calculation
        movement_types={'NoMovement','Random','Sinusoidal','Pitch','Translation'};
        for i=1:length(movement_types)
            filename=[movement_types{i} num2str(1) '.txt'];
            fprintf('%s Calibration Trial...\n',movement_types{i})
            [f_comp,m_comp,f_uncomp,m_uncomp]=validation_test(filename);
            %Saving RMS Data Table
                for j=1:length(movement_types)
                    All_forces(i,j)=cellstr(sprintf('%2.2f +/-  %2.2f',f_comp(j,:)'));
                    All_moments(i,j)=cellstr(sprintf('%2.2f +/- %2.2f',m_comp(j,:)'));
                    %Save Uncompensated Forces at Last Iteration
                        if i==length(movement_types)
                            forces_uncomp(:,j)=cellstr(sprintf('%2.2f +/- %2.2f',f_uncomp(j,:)'));
                            moments_uncomp(:,j)=cellstr(sprintf('%2.2f +/- %2.2f',m_uncomp(j,:)'));
                        end
                end
        end
    %Organize Final Table
        All_forces=[forces_uncomp; All_forces];
        All_moments=[moments_uncomp; All_moments];
    %Saving Table
        file=fullfile([directory_of_this_file filesep 'Results'],'Validation_Test_Results.xlsx');
        xlswrite(file,All_forces,1,'A1')
        xlswrite(file,All_moments,1,'A8')
display('Computation Completed.')