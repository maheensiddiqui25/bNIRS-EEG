  function [Source1 Source2 Source3 Source4] = V_BBS_Sorting(CCD1_Intensity,CCD2_Intensity,ref_ccd1,ref_ccd2)
%BBS_Sorting : inputs: reference files of all 4 sources 
%               outputs: sorted intensity of detectors according to sources
%   Detailed : Sorting and gain compensation
CCD1 = CCD1_Intensity;
CCD2 = CCD2_Intensity;

Source1.TimeMDBBSB = CCD1_Intensity.TimeMDBBSB;
Source2.TimeMDBBSB = CCD1_Intensity.TimeMDBBSB;

Source3.TimeMDBBSB = CCD2_Intensity.TimeMDBBSB;
Source4.TimeMDBBSB = CCD2_Intensity.TimeMDBBSB;

Source1.AndrewTime = CCD1_Intensity.AndrewTime;
Source2.AndrewTime = CCD1_Intensity.AndrewTime;

Source3.AndrewTime = CCD2_Intensity.AndrewTime;
Source4.AndrewTime = CCD2_Intensity.AndrewTime;


%if (CCD1.IntensityBDetector2_a(1,200) > CCD1.IntensityBDetector2_b(1,200))&(CCD2.IntensityBDetector6_a(1,200)<(CCD2.IntensityBDetector6_b(1,200))) 

if (CCD1.IntensityBDetector1_a(1,200) > CCD1.IntensityBDetector1_b(1,200))&(CCD2.IntensityBDetector4_a(1,200)<(CCD2.IntensityBDetector4_b(1,200))) 

    % if true the a is when the light sources is on at position 1 and 3
display('a is location 1 and 3'); 

%% allocating the detectors
Source1.c1d1 = CCD1.IntensityBDetector1_a;
Source1.c2d7 = CCD2.IntensityBDetector7_a;
Source1.c1d3 = CCD1.IntensityBDetector3_a;
Source1.c1d5 = CCD1.IntensityBDetector5_a;
Source1.c1d6 = CCD1.IntensityBDetector6_a;

Source1.TimeMDBBSB = CCD1_Intensity.TimeMDBBSB(1:2:end);
Source1.AndrewTime = CCD1_Intensity.AndrewTime(1:2:end);

Source3.c2d1 = CCD2.IntensityBDetector1_a;
Source3.c2d2 = CCD2.IntensityBDetector2_a;
Source3.c2d3 = CCD2.IntensityBDetector3_a;
Source3.c2d5 = CCD2.IntensityBDetector5_a;
Source3.c2d6 = CCD2.IntensityBDetector6_a;

Source3.TimeMDBBSB = CCD2_Intensity.TimeMDBBSB(1:2:end);
Source3.AndrewTime = CCD2_Intensity.AndrewTime(1:2:end);

 % b is when the light sources is on at position 2 and 4
 
Source2.c1d3 = CCD1.IntensityBDetector3_b;
Source2.c1d4 = CCD1.IntensityBDetector4_b;
Source2.c1d6 = CCD1.IntensityBDetector6_b;
Source2.c1d7 = CCD1.IntensityBDetector7_b;
Source2.c2d1 = CCD2.IntensityBDetector1_b;


Source2.TimeMDBBSB = CCD1_Intensity.TimeMDBBSB(2:2:end);
Source2.AndrewTime = CCD1_Intensity.AndrewTime(2:2:end);

Source4.c2d3 = CCD2.IntensityBDetector3_b;
Source4.c2d4 = CCD2.IntensityBDetector4_b;
Source4.c2d6 = CCD2.IntensityBDetector6_b;
Source4.c2d7 = CCD2.IntensityBDetector7_b;
Source4.c1d2 = CCD1.IntensityBDetector2_b;

Source4.TimeMDBBSB = CCD2_Intensity.TimeMDBBSB(2:2:end);
Source4.AndrewTime = CCD2_Intensity.AndrewTime(2:2:end);



else
    % a is when the light sources is on at position 2 and 4
    % b is when the light sources is on at position 1 and 3

% a is source 2 and 4
display('a is location 2 and 4'); 

Source2.c1d3 = CCD1.IntensityBDetector3_a;
Source2.c1d4 = CCD1.IntensityBDetector4_a;
Source2.c1d6 = CCD1.IntensityBDetector6_a;
Source2.c1d7 = CCD1.IntensityBDetector7_a;
Source2.c2d1 = CCD2.IntensityBDetector1_a;

Source2.TimeMDBBSB = CCD1_Intensity.TimeMDBBSB(1:2:end);
Source2.AndrewTime = CCD1_Intensity.AndrewTime(1:2:end);

Source4.c2d3 = CCD2.IntensityBDetector3_a;
Source4.c2d4 = CCD2.IntensityBDetector4_a;
Source4.c2d6 = CCD2.IntensityBDetector6_a;
Source4.c1d2 = CCD1.IntensityBDetector2_a;

Source4.TimeMDBBSB = CCD2_Intensity.TimeMDBBSB(1:2:end);
Source4.AndrewTime = CCD2_Intensity.AndrewTime(1:2:end);

% b is source 1 and 3
Source1.c1d1 = CCD1.IntensityBDetector1_b;
Source1.c2d7 = CCD2.IntensityBDetector7_b;
Source1.c1d3 = CCD1.IntensityBDetector3_b;
Source1.c1d5 = CCD1.IntensityBDetector5_b;
Source1.c1d6 = CCD1.IntensityBDetector6_b;


Source1.TimeMDBBSB = CCD1_Intensity.TimeMDBBSB(2:2:end);
Source1.AndrewTime = CCD1_Intensity.AndrewTime(2:2:end);

Source3.c2d1 = CCD2.IntensityBDetector1_b;
Source3.c2d2 = CCD2.IntensityBDetector2_b;
Source3.c2d3 = CCD2.IntensityBDetector3_b;
Source3.c2d5 = CCD2.IntensityBDetector5_b;
Source3.c2d6 = CCD2.IntensityBDetector6_b;

Source3.TimeMDBBSB = CCD2_Intensity.TimeMDBBSB(2:2:end);
Source3.AndrewTime = CCD2_Intensity.AndrewTime(2:2:end);

end

%% Wavelengths 
% store the wavelengths in source1 variables
rccd1= load(ref_ccd1);
rccd2= load(ref_ccd2);
Source1.WavelengthC1 = rccd1(:,7);
Source1.WavelengthC2 = rccd2(:,7);


end

