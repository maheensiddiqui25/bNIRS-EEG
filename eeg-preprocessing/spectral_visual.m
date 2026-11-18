%Subject List for each condition 
SubjectNum = [16 17 18 19 20 22 24 25 27 33:34 36 38:39 42:43 46:48 50 54 55];
N = length(SubjectNum);
% Get EEG_data_mat from transform_alleeg
%%

E_conditionXX = EEG_data_mat;
%%%% for condition XX
for j=1:N 
    for i=1:size(E_conditionXX(j).EEG5,2)
            if size(E_conditionXX(j).EEG5(i).data,3) < 13
           % if size(E_conditionXX(j).EEG5(i).epochs,3) < 13
                %for k=size(E_conditionXX(j).EEG5(i).data,3):14
                for k=size(E_conditionXX(j).EEG5(i).data,3):13
                    E_conditionXX(j).EEG5(i).data(:,:,k:13) = NaN;
                end
            end
    end
end


Fs = 500;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 500;                     % Length of signal
t = (0:L-1)*T;                % Time vector
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2+1);

for j=1:N
    for i=1:size(E_conditionXX(j).EEG5,2)
        E1_conditionXX(:,:,:,i,j) = E_conditionXX(j).EEG5(i).data; %for group
        %E1_conditionXX(:,:,:,i) = E_conditionXX(j).EEG5(i).data; %for individual participant
    end
end

E2_conditionXX = squeeze(nanmean(E1_conditionXX,4));

Y_conditionXX = zeros(512,7,32,13,10);
%Y_conditionXX = zeros(512,8,32,13,11);
for m=1:N 
for i=1:5%8%7
    for j=1:32 %no of channels
        for k=1:13 %no of data points in each block
            
               if isnan(E1_conditionXX(j,:,k,i,m))
                   Y_conditionXX(:,i,j,k,m) = NaN;
               else
                   Y_conditionXX(:,i,j,k,m) = fft(E1_conditionXX(j,:,k,i,m),NFFT)/L;
               end
        end
    end
end
end

% Calculate the root mean square power for 5 frequency bands - theta,
% alpha, beta, gamma and high gamma
for i=1:32 % no of channels
        for j=1:N %no of subjects
            rms_conditionXX(:,:,:,i,j,1) = squeeze(rms(Y_conditionXX(4:7,:,i,:,j),1));
            rms_conditionXX(:,:,:,i,j,2) = squeeze(rms(Y_conditionXX(7:10,:,i,:,j),1));
            rms_conditionXX(:,:,:,i,j,3) = squeeze(rms(Y_conditionXX(11:18,:,i,:,j),1));
            rms_conditionXX(:,:,:,i,j,4) = squeeze(rms(Y_conditionXX(22:63,:,i,:,j),1));
            rms_conditionXX(:,:,:,i,j,5) = squeeze(rms(Y_conditionXX(60:80,:,i,:,j),1));
        end
end

rms_conditionXX = squeeze(rms_conditionXX);

rms2_conditionXX = rms_conditionXX;

% Fill in missing values in the block 
for m=1:n %no of blocks
for i=1:N %no of subjects
    for j=1:32 %no of channels 
        for k=1:5 %no of frequency bands
            rms_conditionXX_missingvals(m,:,j,i,k) = fillmissing(rms2_conditionXX(m,:,j,i,k) ,'movmedian',4);
        end
    end
end
end

for p=1:5 %no of frequency bands
for i=1:32  %no of channels 
    for j=1:n %no of blocks
        for k=1:N %no of subjects
            rms2_conditionXX_BL(j,:,i,k,p) = rms_conditionXX_missingvals(j,:,i,k,p)...
                    - squeeze(nanmean(rms_conditionXX_missingvals(j,1:2,i,k,p)));
        end
    end
end
end

for p=1:5 %no of frequency bands
for i=1:32 %no of channels 
    for j=1:n %no of blocks
        for k=1:N %no of subjects
            rms2_conditionXX_conditionXX(j,:,i,k,p) = rms_conditionXX_missingvals(j,:,i,k,p);
        end
    end
end
end



rms2_conditionXX_avg = squeeze(nanmean(rms2_conditionXX_BL,1));
rms2_conditionXX_avg_conditionXX = squeeze(nanmean(rms2_conditionXX_conditionXX,1));

rms2_conditionXX_grand_avg = squeeze(nanmean(rms2_conditionXX_avg,3));
rms2_conditionXX_conditionXX_grand_avg = squeeze(nanmean(rms2_conditionXX_avg_conditionXX,3));
