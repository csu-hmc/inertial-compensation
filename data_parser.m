function parsed_data=data_parser(data)

%=========================================================================
%FUNCTION data_parser:
%      Separates the timestamps, 3D marker coordinates of 5 treadmill 
%      references markers, 3D force plate data (Fx,Fy,Fz,Mx,My,Mz) from two
%      force plates, and 3D accelerations from 4 accelerometers 
%
%--------
%Inputs:
%--------                                   
%      data.textdata (Ndata.textdata x 1)     A cell structure of strings
%                                             of column names as recorded
%                                             from the D-Flow Mocap Module
%      data.data     (Nsamples x m)           A matrix of raw data recorded 
%                                             from the D-Flow Mocap Module, 
%                                             where m is the number of data
%                                             columns in the matrix.
%--------
%Outputs:
%--------
%      parsed_data   (Nsamples x 40)          A matrix containing the data
%                                             of interest of the form:
%                                             [time(1) markers(15) 
%                                             force(12) acceleration(12)]
%=========================================================================

%-------------------------------------------------------------------------
%Parsing Data
%-------------------------------------------------------------------------
    %Timestamps
        timestamps=data.data(:,1)-data.data(1,1);
    %Markers
        markers=data.data(:,3:17);
    %Forces
        forces_left=...
            [data.data(:,find(ismember(data.textdata,'FP1.ForX')))...
            data.data(:,find(ismember(data.textdata,'FP1.ForY')))...
            data.data(:,find(ismember(data.textdata,'FP1.ForZ')))...
            data.data(:,find(ismember(data.textdata,'FP1.MomX')))...
            data.data(:,find(ismember(data.textdata,'FP1.MomY')))...
            data.data(:,find(ismember(data.textdata,'FP1.MomZ')))];
        forces_right=...
            [data.data(:,find(ismember(data.textdata,'FP2.ForX')))...
            data.data(:,find(ismember(data.textdata,'FP2.ForY')))...
            data.data(:,find(ismember(data.textdata,'FP2.ForZ')))...
            data.data(:,find(ismember(data.textdata,'FP2.MomX')))...
            data.data(:,find(ismember(data.textdata,'FP2.MomY')))...
            data.data(:,find(ismember(data.textdata,'FP2.MomZ')))];
        forces=[forces_left forces_right];
    %Accelerations
        accel=...
            [data.data(:,find(ismember(data.textdata,'Acc1.X')))...
            data.data(:,find(ismember(data.textdata,'Acc1.Y')))...
            data.data(:,find(ismember(data.textdata,'Acc1.Z')))...
            data.data(:,find(ismember(data.textdata,'Acc2.X')))...
            data.data(:,find(ismember(data.textdata,'Acc2.Y')))...
            data.data(:,find(ismember(data.textdata,'Acc2.Z')))];

    %Generating Output
        parsed_data=[timestamps markers forces accel];
end

