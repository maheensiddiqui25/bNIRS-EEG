function [ Segmented_Int] = V_BBS_Segmenting(BBS_CCD_Intensity,TimingInput,T0,TEND)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

IntensityBDetector = load(BBS_CCD_Intensity);
IntensityBDetector(:,end+1) = TimingInput(:,1);
IntensityBDetector(:,end+1) = TimingInput(:,2);
IntensityBDetector(:,end+1) = TimingInput(:,3);

%Intensity Detector
IntensityBDetector1=IntensityBDetector(:,(3:514));
IntensityBDetector2=IntensityBDetector(:,(515:1026));
IntensityBDetector3=IntensityBDetector(:,(1027:1538));
IntensityBDetector4=IntensityBDetector(:,(1539:2050));
IntensityBDetector5=IntensityBDetector(:,(2051:2562));
IntensityBDetector6=IntensityBDetector(:,(2563:3074));
IntensityBDetector7=IntensityBDetector(:,(3075:3586));

Segmented_Int.IntensityBDetector1 = IntensityBDetector1;
Segmented_Int.IntensityBDetector2 = IntensityBDetector2;
Segmented_Int.IntensityBDetector3 = IntensityBDetector3;
Segmented_Int.IntensityBDetector4 = IntensityBDetector4;
Segmented_Int.IntensityBDetector5 = IntensityBDetector5;
Segmented_Int.IntensityBDetector6 = IntensityBDetector6;
Segmented_Int.IntensityBDetector7 = IntensityBDetector7;


Segmented_Int.Cycle_Number=IntensityBDetector(:,1);

%Alternative using the timing vector from the MDBBS LabView Software (seems
%better than above as records actual time, not theoretical time)
TimeMDBBSB=IntensityBDetector(:,2);
Segmented_Int.TimeMDBBSB=(TimeMDBBSB-TimeMDBBSB(1))./1000;

Segmented_Int.AndrewTime = (IntensityBDetector(:,end)-IntensityBDetector(1,end));
Segmented_Int.AndrewT0 = (T0 - IntensityBDetector(1,end));
Segmented_Int.AndrewTEND = TEND - IntensityBDetector(1,end);
% Segmented_Int.AndrewTimeInterp = interp(Segmented_Int.AndrewTime,100);

% Segmented_Int.AndrewEndTime = TEND - T0;
% time_file = dir(fileroot);
% finish_time = time_file.datenum;
% 
% TimeMDBBSB_datenum= TimeMDBBSB/60/60/24 + finish_time - TimeMDBBSB(length(TimeMDBBSB))/60/60/24;
% Segmented_Int.TimeMDBBSB_datenum = TimeMDBBSB_datenum;

%Total number of samples
s1=size(IntensityBDetector);
MDBBSB_Index=s1(1);

%% AS THE LIGHT SOURCES WERE ON AND OFF, THE INTENSITY MEASURED BY EACH DETECTOR NEEDS TO BE SEPARATED.

Segmented_Int.IntensityBDetector1_a = IntensityBDetector1(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector1_b = IntensityBDetector1(2:2:s1(1,1),:);

Segmented_Int.IntensityBDetector2_a = IntensityBDetector2(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector2_b = IntensityBDetector2(2:2:s1(1,1),:);

Segmented_Int.IntensityBDetector3_a = IntensityBDetector3(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector3_b = IntensityBDetector3(2:2:s1(1,1),:);

Segmented_Int.IntensityBDetector4_a = IntensityBDetector4(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector4_b = IntensityBDetector4(2:2:s1(1,1),:);

Segmented_Int.IntensityBDetector5_a = IntensityBDetector5(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector5_b = IntensityBDetector5(2:2:s1(1,1),:);

Segmented_Int.IntensityBDetector6_a = IntensityBDetector6(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector6_b = IntensityBDetector6(2:2:s1(1,1),:);

Segmented_Int.IntensityBDetector7_a = IntensityBDetector7(1:2:s1(1,1),:);
Segmented_Int.IntensityBDetector7_b = IntensityBDetector7(2:2:s1(1,1),:);
end

