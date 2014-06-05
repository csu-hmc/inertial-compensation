function [forces_comp,moments_comp,forces_uncomp,moments_uncomp]=validation_test(calibration_trial)

%=========================================================================
%function VALIDATION_TEST
%     1) Loads data of the calibration trial, filters at 6 Hz, clips off
%        first and last second, and adds time delay.
%     2) Loads the data from the remaining trials of the movement type 
%       (filters, clips, adds time delay)
%     3) Uses the calibration trial to determine the matrix of coefficients
%        (compensation.m) and subtracts inertial errors from the remaining
%        trials of the movement type.  Also rotates the corrected forces
%        (transformation.m)
%     4) Calculates the RMS of Fxyz and Mxyz before and after compensation
%        and for all trials and stores in a table
%     5) Calculates the mean and standard deviation in RMS values across
%        all trials of the movement type
%     6) Repeats for the remaining movement types using the same
%        calibration trial
%     7) Produces a final table of the mean and standard deviation of RMS 
%        values of all 5 movement types when compensated with the same 
%        calibration trial 
%
%-------
%Inputs
%-------
%   calibration_trial    (string)      Filename of the trial in which 
%                                      coefficients will be estimated
%--------
%Outputs
%--------
%   forces_comp          (5 x 2)       Description
%   moments_comp         (5 x 2)       Description
%   forces_uncomp        (5 x 2)       Description
%   moments_uncomp       (5 x 2)       Description
%=========================================================================

%-------------------------------------------------------------------------
%Calibration Trial
%-------------------------------------------------------------------------
    %Loading and Parsing
        data_cal=importdata(num2str(calibration_trial));
        data_cal=data_parser(data_cal);
    %Filtering
        [num,den]=butter(2,6/(100/2));
         data_filt_cal=filter(num,den,data_cal(:,2:end));
         data_filt_cal=[data_cal(100:end-100,1) data_filt_cal(100:end-100,:)];
    %Adding Delay
         f_delay=0;                
         a_delay=0.072; 
         [~,~,f_cal,a_cal]=add_delay(data_filt_cal,f_delay,a_delay);
 %------------------------------------------------------------------------
 %Corrections
 %------------------------------------------------------------------------
    movement_types={'NoMovement','Random','Sinusoidal','Pitch','Translation'};
    %Preallocating RMS Tables
        f_comp=zeros(9,1); m_comp=zeros(9,1); f_uncomp=zeros(9,1); m_uncomp=zeros(9,1);
        forces_comp=zeros(5,2); moments_comp=zeros(5,2); 
        forces_uncomp=zeros(5,2); moments_uncomp=zeros(5,2);
    for i=1:length(movement_types)
        for j=2:10
            %Loading Files
                path_to_this_file = mfilename('fullpath');
                [directory_of_this_file, ~, ~] = fileparts(path_to_this_file);
                addpath([directory_of_this_file filesep 'Data' filesep 'Validation-Tests' filesep movement_types{i}])
                filename=[movement_types{i} num2str(j) '.txt'];
            %Loading and Parsing
                data_val=importdata(num2str(filename));
                data_val=data_parser(data_val);
            %Filtering
                data_filt_val=filter(num,den,data_val(:,2:end));
                data_filt_val=[data_val(100:end-100,1) data_filt_val(100:end-100,:)];
            %Adding Delay
                [~,m_val,f_val,a_val]=add_delay(data_filt_val,f_delay,a_delay);
            %Compensating and Rotating
                [compensated_forces]=compensation(f_cal,a_cal,f_val,a_val); 
                rotated_forces=transformation(m_val,compensated_forces);
            %Statistics
                f_uncomp(j-1,:)=norm(sqrt(mean(f_val(:,1:3).^2)));
                m_uncomp(j-1,:)=norm(sqrt(mean(f_val(:,4:6).^2)));
                f_comp(j-1,:)=norm(sqrt(mean(rotated_forces(:,1:3).^2)));
                m_comp(j-1,:)=norm(sqrt(mean(rotated_forces(:,4:6).^2)));
        end
        %Organize Final Statistics Table
            forces_uncomp(i,:)=[mean(f_uncomp) std(f_uncomp)];
            moments_uncomp(i,:)=[mean(m_uncomp) std(m_uncomp)];
            forces_comp(i,:)=[mean(f_comp) std(f_comp)];
            moments_comp(i,:)=[mean(m_comp) std(m_comp)];    
    end
end