function [time_delay,markers_delay,force_delay,accel_delay]=add_delay(data,force_delay,acc_delay)

%=========================================================================
%function ADD_DELAY
%      Adds a time delay to force and acceleration signals and clips any
%      NaN that might appear in the data after shifting 
%
%-------
%Inputs
%-------
%     data        (Nsamples x 40)  Data array of the form:
%                                  [Time(1) Markers(15) Force(12) Accel(12)]
%     force_delay (double)         The time delay between the markers and
%                                  recorded forces
%     acc_delay   (double)         The time delay between the markers and
%                                  recorded accelerometer data 
%
%--------
%Outputs
%--------
%     time_delay        (Nsamples-NaN x 1)   Vector of timestamps
%     markers_delay     (Nsamples-NaN x 15)  Array of 3D coordinates of
%                                            5 treadmill markers
%     force_delay       (Nsamples-NaN x 12)  Array of force plate signals
%                                            from both force plates of the 
%                                            form: [Fx Fy Fz Mx My Mz]
%     accel_delay       (Nsamples-NaN x 12)  Array of 3D accelerations from
%                                            4 accelerometers 
%=========================================================================

%--------------------
%Declaring Variables
%--------------------
    time=data(:,1);
    markers=data(:,2:16);
    force=data(:,17:28);
    accel=data(:,29:end);
%---------------------
%Adding Signal Delays  
%---------------------
    force_delay=interp1(time,force,time+force_delay);
    accel_delay=interp1(time,accel,time+acc_delay);
%---------------------------------------------
%Removing all NaN from the Original Matrices
%---------------------------------------------
    new_frame=find(isnan(accel_delay), 1 )-1;
    time_delay=time(1:new_frame,:);
    markers_delay=markers(1:new_frame,:);
    force_delay=force_delay(1:new_frame,:);
    accel_delay=accel_delay(1:new_frame,:);
end
