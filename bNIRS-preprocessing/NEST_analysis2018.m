
clear
tic
SubjectNum = % XX
NumofSessions =  %XX 
NumofConditions = %XX  

BaseDir = fullfile('~/YourDataLocation',sprintf('NEST_%d', SubjectNum));

%load data
 
 DataC1Pattern  = sprintf('NEST_XX_Data_C1.txt',SubjectNum);
 DataC2Pattern  = sprintf('NEST_XX_Data_C2.txt',SubjectNum);
 TimingPattern  = sprintf('NEST_XX_Timing.txt',SubjectNum);
 SerialPattern  = sprintf('serialcapture.txt');

 DataInput      = {DataC1Pattern, DataC2Pattern};    
 TimingInput    = load(TimingPattern);
 SerialCapture  = load(SerialPattern);

 RefInput       = {'subject7_160517_phong_ref_C1.txt','subject7_160517_phong_ref_C2.txt'};

%% Time 
%if strcmp(ResultsInput.results.presentationType,'Epoch')
%SerialCapture  arrary of eventmarkers sent to the acqusition computer in matlab time 
%LabViewVec     produces a vector of 1/1/04: timestamping in LabView is based on the number of seconds from 1/1/04
%serialvec      creates a vector of all of the timestamps in the SerialCapture array
%LabViewTime    the conversion of serial capture times into labview time
%serialsecs     extracts the hours, mins and seconds from serialcapture converts into seconds
%serialsecdiff  the time in serialcapture from the start of the first event in serialcapture
%T0             T0 is the timestamp(in LabView time) when the experiement started
%TEND           TEND is the timestamp(in LabView time) when the experiement ended


SerialCaptureEpoch = SerialCapture(find(SerialCapture(:,2) == 9992):(find((SerialCapture(:,2)==11),1,'last')),:);

LabViewVec   =  datevec('01-Jan-1904');
for i = 1:length(SerialCaptureEpoch) 
    serialvec(i,:) = datevec(SerialCaptureEpoch(i,1));
    LabViewTime(i,:) = etime(serialvec(i,:),LabViewVec);
end

serialsecs = serialvec(:,4:6);
serialsecs = serialsecs(:,1)*3600 + serialsecs(:,2)*60 + serialsecs(:,3);
serialsecdiff = serialsecs - serialsecs(1);

SerialCaptureEpoch(:,3) = serialsecdiff;
SerialCaptureEpoch(:,4) = LabViewTime;

T0   = SerialCaptureEpoch((SerialCaptureEpoch(:,2)==9992),4); %select the start of the experiment in labview time
TEND = SerialCaptureEpoch((find((SerialCaptureEpoch(:,2)==11),1,'last')),4); %select the end of the experiment in labview time

TimingInput(:,4) = TimingInput(:,3) - T0;
TimingInput(:,5) = TEND - TimingInput(:,3);

startIndex = find((TimingInput(:,4)>0),1,'first');
endIndex = find((TimingInput(:,5)>0),1,'last');


%%
  DMAT.names = {'Soc' 'NonSoc' 'RG' 'BW' 'LC' 'HC' 'BL'};
  DMAT.onsets = {[SerialCaptureEpoch((SerialCaptureEpoch(:,2)==41),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==43),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==23),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==21),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==31),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==33),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==10),3)]};
  DMAT.offsets = {[SerialCaptureEpoch((SerialCaptureEpoch(:,2)==42),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==44),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==24),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==22),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==32),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==34),3)] [SerialCaptureEpoch((SerialCaptureEpoch(:,2)==11),3)]};
  
  for i=1:7
    DMAT.durations{1,i} = DMAT.offsets{1,i} - DMAT.onsets{1,i};
    DMAT.durations_round{1,i} = round(DMAT.durations{1,i});
  end


%% Segmenting into CCD based on the multiplexing sequences
[CCD1] = V_BBS_Segmenting(DataInput{1},TimingInput,T0,TEND);
[CCD2] = V_BBS_Segmenting(DataInput{2},TimingInput,T0,TEND);

%% BBS_sorting:Sort all the dectector intensities into 4 sources and do gain compensation
[S1 S2 S3 S4] = V_BBS_Sorting(CCD1,CCD2,RefInput{1},RefInput{2});

%% MBL for all detectors
wavelength_start = 780;
wavelength_end   = 900;
distance = 2.5;       
distance_long = 2.895;
%Source 1

 [s1_c1d1] = V_BBS_MBL(S1.c1d1,S1.WavelengthC1,S1.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s1_c1d3] = V_BBS_MBL(S1.c1d3,S1.WavelengthC2,S1.TimeMDBBSB,wavelength_start,wavelength_end,distance_long,T0);%,time_finish);
 [s1_c1d5] = V_BBS_MBL(S1.c1d5,S1.WavelengthC2,S1.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s1_c1d6] = V_BBS_MBL(S1.c1d6,S1.WavelengthC2,S1.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 
 [s1_c2d7] = V_BBS_MBL(S1.c2d7,S1.WavelengthC1,S1.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 
%Source 2 

 [s2_c1d3] = V_BBS_MBL(S2.c1d3,S1.WavelengthC1,S2.TimeMDBBSB,wavelength_start,wavelength_end,distance_long,T0);%,time_finish);
 [s2_c1d4] = V_BBS_MBL(S2.c1d4,S1.WavelengthC1,S2.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s2_c1d6] = V_BBS_MBL(S2.c1d6,S1.WavelengthC1,S2.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s2_c1d7] = V_BBS_MBL(S2.c1d7,S1.WavelengthC2,S2.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 
 [s2_c2d1] = V_BBS_MBL(S2.c2d1,S1.WavelengthC2,S2.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);

%Source 3 

 [s3_c2d1] = V_BBS_MBL(S3.c2d1,S1.WavelengthC1,S3.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s3_c2d2] = V_BBS_MBL(S3.c2d2,S1.WavelengthC1,S3.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s3_c2d3] = V_BBS_MBL(S3.c2d3,S1.WavelengthC2,S3.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s3_c2d5] = V_BBS_MBL(S3.c2d5,S1.WavelengthC2,S3.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s3_c2d6] = V_BBS_MBL(S3.c2d6,S1.WavelengthC2,S3.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 
%Source 4

 [s4_c2d3] = V_BBS_MBL(S4.c2d3,S1.WavelengthC1,S4.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s4_c2d4] = V_BBS_MBL(S4.c2d4,S1.WavelengthC1,S4.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 [s4_c2d6] = V_BBS_MBL(S4.c2d6,S1.WavelengthC2,S4.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 
 [s4_c1d2] = V_BBS_MBL(S4.c1d2,S1.WavelengthC2,S4.TimeMDBBSB,wavelength_start,wavelength_end,distance,T0);%,time_finish);
 
%%
 idx1 = size(s1_c1d3.DPFInVariant_DeltaConcentrations_Detector1,1);
 idx2 = size(s2_c1d3.DPFInVariant_DeltaConcentrations_Detector1,1);
 idx = max(idx1,idx2);
 numchan = 19;
 channels=NaN(idx,3,numchan);

 channels(1:idx1,:,1)= s1_c1d1.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,2)= s1_c2d7.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,3)= s1_c1d3.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,4)= s1_c1d5.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,5)= s1_c1d6.DPFInVariant_DeltaConcentrations_Detector1;
  
 channels(1:idx2,:,6)= s2_c1d3.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,7)= s2_c1d4.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,8)= s2_c1d6.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,9)= s2_c1d7.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,10)= s2_c2d1.DPFInVariant_DeltaConcentrations_Detector1;

 channels(1:idx1,:,11)= s3_c2d1.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,12)= s3_c2d2.DPFInVariant_DeltaConcentrations_Detector1; 
 channels(1:idx1,:,13)= s3_c2d3.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,14)= s3_c2d5.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx1,:,15)= s3_c2d6.DPFInVariant_DeltaConcentrations_Detector1;
 
 channels(1:idx2,:,16)= s4_c2d3.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,17)= s4_c2d4.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,18)= s4_c2d6.DPFInVariant_DeltaConcentrations_Detector1;
 channels(1:idx2,:,19)= s4_c1d2.DPFInVariant_DeltaConcentrations_Detector1;
 
 %% AndrewInterpolation and cut-off

bx = 0:1:max(CCD1.AndrewTime);
ANDalldata = zeros(length(bx),3,19);
 ExpStart = round(CCD1.AndrewT0);% * 10);
 ExpEnd = round(CCD1.AndrewTEND);% * 10);

 for i = 1:19
     if  i<=5
         time = S1.AndrewTime;
     elseif  i>5 & i <=10
         time = S2.AndrewTime;
     elseif  i>10 & i <=15
         time = S3.AndrewTime;
     else
         time = S4.AndrewTime;
     end
     
     idxnan = isnan(channels(:,1,i));
     idxsignal = idxnan==0;
     ANDalldata(:,1,i)= interp1(time,channels(idxsignal,1,i),0:1:max(CCD1.AndrewTime));
     ANDalldata(:,2,i)= interp1(time,channels(idxsignal,2,i),0:1:max(CCD1.AndrewTime));
     ANDalldata(:,3,i)= interp1(time,channels(idxsignal,3,i),0:1:max(CCD1.AndrewTime));
     
    
 end
 
 EXPdata =  ANDalldata(ExpStart:ExpEnd,:,:);


%% Filtering

[B, A] = butter(4,[0.01 0.4]./0.5);

for i = 1:19
   for ii = 1:3
        EXPfiltdata(:,ii,i) = filtfilt(B,A,EXPdata(:,ii,i));
   end
end

%% Reject channels with poor data quality 
Channel_Reject;

%%
chans=[1 2 3 4 5 9 11:18];
for i= 1:14
      figure;
      chnum1 = chans(i);%patt(i);% grid(i);
        plot(EXPfiltdata(:,1,chnum1),'r','LineWidth',2);hold on; 
        plot(EXPfiltdata(:,2,chnum1),'b','LineWidth',2);hold on;
        plot(EXPfiltdata(:,3,chnum1)*2.5,'g','LineWidth',2);hold on;
        title(strcat('Band Ch ',num2str(chnum1)))
end
%%

figure;
for i= 1:18

       chnum1 = i;%patt(i);% grid(i);
       subplot(3,1,1);
        plot(EXPfiltdata(:,1,chnum1),'r','LineWidth',2);hold on;
         line([(DMAT.onsets{1,1}(:)) (DMAT.onsets{1,1}(:))],[-1 1],'LineWidth',1,'Color','y');
         line([(DMAT.onsets{1,2}(:)) (DMAT.onsets{1,2}(:))],[-1 1],'LineWidth',1,'Color','m');
         line([(DMAT.onsets{1,3}(:)) (DMAT.onsets{1,3}(:))],[-1 1],'LineWidth',1,'Color','c');
         line([(DMAT.onsets{1,4}(:)) (DMAT.onsets{1,4}(:))],[-1 1],'LineWidth',1,'Color','g');

         line([(DMAT.onsets{1,5}(:)) (DMAT.onsets{1,5}(:))],[-1 1],'LineWidth',1,'Color','b')
         line([(DMAT.onsets{1,6}(:)) (DMAT.onsets{1,6}(:))],[-1 1],'LineWidth',1,'Color','r')
        
       subplot(3,1,2);
        plot(EXPfiltdata(:,2,chnum1),'b','LineWidth',2);hold on;
         line([(DMAT.onsets{1,1}(:)) (DMAT.onsets{1,1}(:))],[-1 1],'LineWidth',1,'Color','y');
         line([(DMAT.onsets{1,2}(:)) (DMAT.onsets{1,2}(:))],[-1 1],'LineWidth',1,'Color','m');
         line([(DMAT.onsets{1,3}(:)) (DMAT.onsets{1,3}(:))],[-1 1],'LineWidth',1,'Color','c');
         line([(DMAT.onsets{1,4}(:)) (DMAT.onsets{1,4}(:))],[-1 1],'LineWidth',1,'Color','g');

         line([(DMAT.onsets{1,5}(:)) (DMAT.onsets{1,5}(:))],[-1 1],'LineWidth',1,'Color','b')
         line([(DMAT.onsets{1,6}(:)) (DMAT.onsets{1,6}(:))],[-1 1],'LineWidth',1,'Color','r')
        
         subplot(3,1,3);
          plot(EXPfiltdata(:,3,chnum1)*2.5,'g','LineWidth',2);hold on;
         line([(DMAT.onsets{1,1}(:)) (DMAT.onsets{1,1}(:))],[-1 1],'LineWidth',1,'Color','y');
         line([(DMAT.onsets{1,2}(:)) (DMAT.onsets{1,2}(:))],[-1 1],'LineWidth',1,'Color','m');
         line([(DMAT.onsets{1,3}(:)) (DMAT.onsets{1,3}(:))],[-1 1],'LineWidth',1,'Color','c');
         line([(DMAT.onsets{1,4}(:)) (DMAT.onsets{1,4}(:))],[-1 1],'LineWidth',1,'Color','g');

         line([(DMAT.onsets{1,5}(:)) (DMAT.onsets{1,5}(:))],[-1 1],'LineWidth',1,'Color','b')
         line([(DMAT.onsets{1,6}(:)) (DMAT.onsets{1,6}(:))],[-1 1],'LineWidth',1,'Color','r')
     
title(strcat('Band Ch ',num2str(chnum1)))

end

