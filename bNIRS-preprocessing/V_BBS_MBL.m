function [ChanB_MDBBS] = BBS_MBL(detector_intensity,wavelengths,TimeMDBBSB,Wavelength_Start,Wavelength_End,distance,T0) %,time_finish)

%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
%% Time Sychronisation 
% time_start = time_finish - TimeMDBBSB(length(TimeMDBBSB))/60/60/24;
% TimeMDBBSB_datenum = TimeMDBBSB/60/60/24+ time_start ; 
% ChanB_MDBBS.TimeMDBBSB = TimeMDBBSB;
% ChanB_MDBBS.TimeMDBBSB_datenum = TimeMDBBSB_datenum;

ChanB_MDBBS.T0 = T0;

%%
IntensityBDetector1 = detector_intensity;
ChanB_MDBBS.IntensityBDetector = IntensityBDetector1;
lambda_range1 = find(wavelengths > Wavelength_Start,1,'first');
lambda_range2 = find(wavelengths > Wavelength_End,1,'first');
lambda_resolution = lambda_range2 - lambda_range1 +1;
ChanB_MDBBS.lambda_resolution = lambda_resolution;

ChanB_MDBBS.Wavelengths = wavelengths;
WavelengthsB_Operating=ChanB_MDBBS.Wavelengths(lambda_range1:lambda_range2);
% WavelengthsB_Operating(1,:) = ChanB_MDBBS.Wavelengths(lambda_range1); 
% WavelengthsB_Operating(2,:) = ChanB_MDBBS.Wavelengths(lambda_range2); 

ChanB_MDBBS.Operating_WavelengthsB = WavelengthsB_Operating;

Operating_IntensityBDetector1=IntensityBDetector1(:,lambda_range1:lambda_range2);
ChanB_MDBBS.Operating_IntensityBDetector = Operating_IntensityBDetector1;

s1 = size(Operating_IntensityBDetector1);
MDBBSB_Index=s1(1);
IntensityR=100000;

AttenuationB_Detector1 = zeros(s1);

for i=1:MDBBSB_Index,
       AttenuationB_Detector1(i,:)=log10(IntensityR./Operating_IntensityBDetector1(i,:));  
end
ChanB_MDBBS.AttenuationB_Detector1=AttenuationB_Detector1;

%---------------------------%
% Concentration Calculation-%
%---------------------------%

%Load specific extinction coefficient table

%Wavelengths(nm)	Water (OD/M/cm)	HbO2 (OD/M/cm)	HHb (OD/M/cm) ox-redCCO (OD/M/cm)
coeff=tissue_specific_extinction_coefficient_650to1000;

%Wavelengths(nm)	Water (OD/cm)	
water_coeff=water_specific_extinction_spectrum_37Celcius;

%Wavelength dependency of DPF
DPF_Lambda_Dependency=DPF_Lambda_Dependency_740to915;

%Selection of wavelength range for concentration calculation be careful that
%information of wavelength dependency of pathlength is from 740nm to 915nm.
lambda1=find(ChanB_MDBBS.Operating_WavelengthsB >= Wavelength_Start,1,'first');
lambda2=find(ChanB_MDBBS.Operating_WavelengthsB >= Wavelength_End,1,'first');
lambda_fitting_resolution=lambda2-lambda1;

Concentration_Fitting_Wavelengths=ChanB_MDBBS.Operating_WavelengthsB(lambda1:lambda2);
ChanB_MDBBS.Concentration_Fitting_Wavelengths=Concentration_Fitting_Wavelengths; 

%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Construct SpecExt Matrix for HbO2, HHb and oxCCO  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The SpecExtCoef Matrix is corrected for the wavelength dependency of pathlength  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ABSMAT=[];
LDPF=[];
for i=1:lambda_fitting_resolution+1, %Wavelength Range according to wavelength selection
   
   index_lambda=find(coeff(:,1)==round(ChanB_MDBBS.Concentration_Fitting_Wavelengths(i)));  % index for the wavelength in the tissue specific extinction coeff table
   % wl(i)=coeff(index_lambda,1);%w1 holds the wavelengths that correspond to the fitting wavelengths. Why need it???
   
   if Wavelength_Start<740, 
      LDPF(1:lambda_fitting_resolution+1)=1;
   
   elseif Wavelength_End>915,
          LDPF(1:lambda_fitting_resolution+1)=1;
   %so in these cases you essentially don't apply the lambbda dependency
   
   else
   %Wavelength Dependency of Pathlength
   index_lambda2=find(DPF_Lambda_Dependency(:,1)==round(ChanB_MDBBS.Concentration_Fitting_Wavelengths(i)));  % index for the wavelength in the lambda-dependency table
   LDPF(i)=DPF_Lambda_Dependency(index_lambda2,2);%LDPF holds the lambda dependency coefficients that correspond to the fitting wavelengths
   end
   
 %   ABSMAT(i,4)=coeff(index_lambda,2)*log(10);    % [water OD/M/cm]
   
%    ABSMAT(i,1)=coeff(index_lambda,3)*log(10)*LDPF(i);     % [HbO2 OD/M/cm] alpha=epsilon*ln(10)
%    ABSMAT(i,2)=coeff(index_lambda,4)*log(10)*LDPF(i);     % [HHb OD/M/cm]                                 
%    ABSMAT(i,3)=coeff(index_lambda,5)*log(10)*LDPF(i);     % [ox-redCCO OD/M/cm] 
   
   ABSMAT(i,1)=coeff(index_lambda,3)*LDPF(i);%*log(10);     % [HbO2 OD/M/cm] epsilon
   ABSMAT(i,2)=coeff(index_lambda,4)*LDPF(i);%*log(10);     % [HHb OD/M/cm]                                 
   ABSMAT(i,3)=coeff(index_lambda,5)*LDPF(i);%*log(10);     % [ox-redCCO OD/M/cm] 
   %ABSMAT(i,3)=coeff(index_MDFD_lambda,6)*log(10);    % [oxCCO OD/M/cm]
   %ABSMAT(i,4)=coeff(index_MDFD_lambda,7)*log(10);    % [redCCO OD/M/cm]   
   ABSMAT_errcalc = ABSMAT;

end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 ChanB_MDBBS.DeltaAttenuationB_Detector1 = bsxfun(@minus,ChanB_MDBBS.AttenuationB_Detector1(:,lambda1:lambda2),ChanB_MDBBS.AttenuationB_Detector1(1,lambda1:lambda2));
%DIFFERENTIAL SPECTROSCOPY                                  
%
%Calculate Concentration Changes by calculating the Changes in Attenuation 
%For detectors 1(3.5cm) and 2(3.0cm) use MDFD measured 790nm pathlength
%Use either time invariant or time variant pathlength
%For detectors 3(2.5cm) and 4(2.0cm) use fix DPF of 6.26*Optode Distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%Wavelet based motion correction applied to Delta Attenuation, WMC -
%Wavelet based Motion Correction 

    ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC1 =  ChanB_MDBBS.DeltaAttenuationB_Detector1;
    for i=1:size(ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC1,2)
        ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC2 = (ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC1(:,i));
   %     ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC2 =  ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC2';
        
   ChanB_MDBBS.WMC=hmrMotionCorrectWavelet(ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC2,1.5);
   
   ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC(:,i)=ChanB_MDBBS.WMC; % ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC is the motion corrected signal
        %sprintf('Performing Motion Correction, this is wavelength #%d', i)
    end
%     

 %ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC = ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC';
    
   
     %ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC =  ChanB_MDBBS.DeltaAttenuationB_Detector1;
   
%end
%%

%-------------------------------------------------------------%
% Alternative Way 3 (using least square matrix inversion) 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%-------------------------------------------------------------%

%matrix inversion (M.cm/OD) you can use pinv instead of inv
PIMAT_MDBBS=[];
PIMAT_MDBBS=inv(ABSMAT'*ABSMAT)*ABSMAT';
ChanB_MDBBS.PIMAT_MDBBS = PIMAT_MDBBS;

%DPFInVariant_DeltaConcentrations_Detector1 = zeros(size(ChanB_MDBBS.DeltaAttenuationB_Detector1,1),size(PIMAT_MDBBS,1));
DPFInVariant_DeltaConcentrations_Detector1 = zeros(size(ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC,1),size(PIMAT_MDBBS,1));


%for i=1:size(ChanB_MDBBS.DeltaAttenuationB_Detector1,1)
for i=1:size(ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC,1)
%Multiply by 1000000 to convert to uM
%DPFInVariant_DeltaConcentrations_Detector1(i,:)=(1000000)*PIMAT_MDBBS*(ChanB_MDBBS.DeltaAttenuationB_Detector1(i,:)./(distance*6.26))';
DPFInVariant_DeltaConcentrations_Detector1(i,:)=(1000000)*PIMAT_MDBBS*(ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC(i,:)./(distance*5.13))';
end

ChanB_MDBBS.DPFInVariant_DeltaConcentrations_Detector1=DPFInVariant_DeltaConcentrations_Detector1;

dAtt=(DPFInVariant_DeltaConcentrations_Detector1(:,1)*ABSMAT_errcalc(:,1)')+(DPFInVariant_DeltaConcentrations_Detector1(:,2)*ABSMAT_errcalc(:,2)')+(DPFInVariant_DeltaConcentrations_Detector1(:,3)*ABSMAT_errcalc(:,3)');
%ChanB_MDBBS.DPFInVariant_DeltaError_Detector1=(ChanB_MDBBS.DeltaAttenuationB_Detector1(:,:)'-(dAtt(:,:)*distance*6.26/1000000)');
ChanB_MDBBS.DPFInVariant_DeltaError_Detector1=(ChanB_MDBBS.DeltaAttenuationB_Detector1_WMC(:,:)'-(dAtt(:,:)*distance*5.13/1000000)');
ChanB_MDBBS.dAtt =(dAtt(:,:)*(distance*5.13)/1000000);
ChanB_MDBBS.ABSMAT_errcalc = ABSMAT_errcalc;

% %% Create Markers for the Stimulation Periods
% 
% Marker_Times = zeros(size(stim));
% 
% for i = 1:length(stim)
%     Marker_Times(i)=find(TimeMDBBSB_datenum > stim(i),1,'first');
% end
% 
% y = zeros(size(DPFInVariant_DeltaConcentrations_Detector1,1),1);
% 
% ChanB_MDBBS.Marker_Times = Marker_Times;
% y(Marker_Times)=1;
% ChanB_MDBBS.Markers = y;


%% HbT and HbDiff

ChanB_MDBBS.HbT =DPFInVariant_DeltaConcentrations_Detector1(:,1)+ DPFInVariant_DeltaConcentrations_Detector1(:,2);
ChanB_MDBBS.HbDiff =DPFInVariant_DeltaConcentrations_Detector1(:,1)- DPFInVariant_DeltaConcentrations_Detector1(:,2);

end

