%% Batch EEG preprocessing
% Batch processes EEG datasets across subjects.
% Applies bandpass and notch filtering, adds electrode location information,
% segments events into epochs, performs baseline correction, removes trials
% previously rejected during NIRS processing, and interpolates bad channels.
%
% Subject-specific processing results are saved as separate EEGLAB datasets.


% Define subject IDs to be processed and determine the total number of subjects.
% Specify input and output directories for the EEG datasets.
SubjectNum = %List of subjects numbers e.g. [15 16 17 18 19 20 22 23 24 25 26 27 28 29 30 31:56];
N = length(SubjectNum);

filePathSave = % Path to where you want to save the data
filePath = % Path to data

%% Bandpass and notch filtering
% Apply a 0.1–100 Hz Butterworth bandpass filter to EEG channels 1–32.
% Remove the DC offset during filtering.
% Save the bandpass-filtered dataset.
%
% Subsequently apply a 50 Hz notch filter to remove line noise.
% Save the notch-filtered dataset separately.
for i = 1:N 
    
    j = SubjectNum(i); 
    
    EEG = ALLEEG(i);
    fileName_load = ALLEEG(i).filename;
    %EEG = pop_loadset('filename',fileName_load,'filepath',filePath);
    EEG = eeg_checkset( EEG );
    
    %eeglab redraw 

    fileName_segmented = sprintf('NEST_%d_filt_0.1_100.set',j);
    setName_segmented = sprintf('NEST_%d_filt_0.1_100',j);
    fileName_BL_rm = sprintf('NEST_%d_filt_notch.set',j);
    setName_BL_rm = sprintf('NEST_%d_filt_notch',j);
    
    EEG.setname = setName_segmented;
    EEG  = pop_basicfilter( EEG,  1:32 , 'Cutoff', [ 0.1 100], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2, 'RemoveDC', 'on' ); % GUI: 10-Mar-2018 11:20:48
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',fileName_segmented,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );
    eeglab redraw
    

    EEG.setname = setName_BL_rm;
    EEG  = pop_basicfilter( EEG,  1:32 , 'Cutoff',  50, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180, 'RemoveDC', 'on' ); % GUI: 29-Jan-2018 09:56:34
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',fileName_BL_rm,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );
  
    eeglab redraw
end

%% Add electrode location information
% Load the electrode location file and assign channel coordinates to the
% EEG datasets. Electrode locations are centred using pop_chancenter.
% Save the datasets with the updated channel location information.
filePathSave3 = % Path to where you want to save the data
for i = 1:N
    
    j = SubjectNum(i); 
  
    EEG = ALLEEG(i);
    EEG = eeg_checkset( EEG );
    EEG = pop_chanedit(EEG, 'load',{'/YOURPATH/LOCATION_FILE.locs' 'filetype' 'autodetect'},'eval','chans = pop_chancenter( chans, [],[]);');
    
    fileName_chans = sprintf('NEST_%d_notch_correctchans.set',j);
    setName_chans = sprintf('NEST_%d_notch_correctchans',j);
    EEG.setname = setName_chans;
    
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',fileName_chans,'filepath',filePathSave3);
    
    
end
%% Mark events for condition-specific processing
% Identify the relevant experimental condition and assign its corresponding
% condition label.
% Mark events for exclusion using the NEST_mark_bad_BW_events function.
% This step incorporates trial rejection information from the corresponding
% NIRS data.

filePathSave = % Path to where you want to save the data
filePath = % Path to data

for i = 1:N
    k = 41;
    condition = k; 
    if condition==41
        conditionLabel = 'Soc';
    elseif condition==43
        conditionLabel = 'NonSoc';
    elseif condition==31
        conditionLabel = 'LC';
    elseif condition==33
        conditionLabel = 'HC';
    elseif condition==21 
        conditionLabel = 'BW';
    elseif condition==23        
        conditionLabel = 'RG';
    end
    j = SubjectNum(i); 
    eventtype = 41; 
    OUTEEG(i) = NEST_mark_bad_BW_events(ALLEEG(i),eventtype,cell2mat(LT_trials_hc{1,i}));
    
    fileName_new = sprintf('NEST_%d_notch_%s_evs.set',j,conditionLabel);
    setName_new = sprintf('NEST_%d_notch_%s_evs',j,conditionLabel);
    
    OUTEEG(i).filename = fileName_new;
    OUTEEG(i).setname = setName_new;
    OUTEEG(i).filepath = filePathSave;
    
   % EEG = pop_saveset( OUTEEG(i), 'filename',fileName_new,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );
end



%% Epoch segmentation and baseline correction
% Segment continuous EEG data into epochs time-locked to the selected
% experimental event.
% Epochs extend from 200 ms before event onset to 800 ms after event onset.
%
% Apply baseline correction using the pre-stimulus interval (-200 to 0 ms).
% Save both the segmented and baseline-corrected datasets separately.


%path to save epochs
filePathSave =  % Path to where you want to save the data

%path to save baseline corrected epoch
filePathSave2 =  % Path to where you want to save the data

% Retrieve the trial rejection information generated during NIRS processing.
% Remove EEG epochs corresponding to trials previously rejected during
% NIRS quality control, ensuring that EEG and NIRS analyses use matching
% trial selections.
%
% If no NIRS-rejected trials are present, retain all baseline-corrected
% EEG epochs.
%path to save baseline corrected epochs with NIRS LT trials removed 
filePathSaveRejTrials =  % Path to where you want to save the data

for i = 1:N
    %rej_epoch_vec = [];
    
    j = SubjectNum(i); 
    
    fileName_load = ALLEEG(i).filename;
    k = 93;
    condition = k; 
    if condition==62
        conditionLabel = 'BW';
    elseif condition==72
        conditionLabel = 'RG';
    elseif condition==83
        conditionLabel = 'LC';
    elseif condition==93
        conditionLabel = 'HC';
    elseif condition==411
        conditionLabel = 'Soc';
    elseif condition==431
        conditionLabel = 'NonSoc';
    end
    
    Labels = {'BW';'RG';'LC';'HC';'Soc';'NonSoc'};
    
    fileName_segmented = sprintf('NEST_%d_notch_segmented_%s.set',j,conditionLabel);
    setName_segmented = sprintf('NEST_%d_notch_segmented_%s',j,conditionLabel);
    fileName_BL_rm = sprintf('NEST_%d_notch_segmented_bl_rm_%s',j,conditionLabel);
    setName_BL_rm = sprintf('NEST_%d_notch_segmented_bl_rm_%s',j,conditionLabel);
    fileName_LTrejtrials = sprintf('NEST_%d_notch_segmented_bl_rm_rejtrials_%s',j,conditionLabel);
    setName_LTrejtrials = sprintf('NEST_%d_notch_segmented_bl_rm_rejtrials_%s',j,conditionLabel);
    
    cond = sprintf('%d',condition);
    
    %segment into epochs 
    OUTEEG(i) = pop_epoch( ALLEEG(i), {  cond  }, [-0.2  0.8], 'newname', fileName_segmented, 'epochinfo', 'yes'); %select the event 
    
    %save epochs 
    EEG = pop_saveset( OUTEEG(i), 'filename',fileName_segmented,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );
    
    %baseline correct epochs 
    OUTEEG2(i) = pop_rmbase( OUTEEG(i), [-200 0]);
    
    %save baseline corrected epochs
    OUTEEG2(i).setname = setName_BL_rm;
    OUTEEG2(i).filename = fileName_BL_rm;
    OUTEEG2(i).filepath = filePathSave2; 
   
    EEG = pop_saveset( OUTEEG2(i), 'filename',fileName_BL_rm,'filepath',filePathSave2);
    EEG = eeg_checkset( EEG );
    
    if isfield(ALLEEG(i).event,'rejepochsNIRS')
        rej_epoch_vec=ALLEEG(i).event(1).rejepochsNIRS;
    else
        rej_epoch_vec = [];
    end
    
    if ~isempty(rej_epoch_vec)
    % reject trials that have been rejected for the NIRS after segmentation has been performed 

    OUTEEG3(i)= pop_rejepoch(OUTEEG2(i),rej_epoch_vec,0);
    
    %save baseline corrected epochs with rejected trials removed
    OUTEEG3(i).setname = setName_LTrejtrials;
    OUTEEG3(i).filename = fileName_LTrejtrials;
    OUTEEG3(i).filepath = filePathSaveRejTrials; 
    
    EEG = pop_saveset( OUTEEG3(i), 'filename',fileName_LTrejtrials,'filepath',filePathSaveRejTrials);
    EEG = eeg_checkset( EEG );
    
    elseif isempty(rej_epoch_vec)
        
    OUTEEG3 = OUTEEG2;
    OUTEEG3(i).setname = setName_LTrejtrials;
    OUTEEG3(i).filename = fileName_LTrejtrials;
    OUTEEG3(i).filepath = filePathSaveRejTrials; 
    
    EEG = pop_saveset( OUTEEG3(i), 'filename',fileName_LTrejtrials,'filepath',filePathSaveRejTrials);
    EEG = eeg_checkset( EEG );
        
    end
    
    
     
end

%% Interpolate bad electrodes: BW condition
% Define subject-specific lists of electrodes identified as bad during
% EEG quality control.
% Interpolate the specified electrodes using spherical interpolation.
% Subjects with empty electrode lists do not require channel interpolation.
% Save the resulting datasets with interpolated channels.

electrode_list = {};
electrode_list{1}={Oz P4}; %NEST_16
electrode_list{2} = {Cz Pz C2 PO4 PO3 }; %NEST_17
electrode_list{3} = {C2}; %18
electrode_list{4} = {Cz Pz PO3 C2 PO4}; %19
electrode_list{5} = {C3 C2}; %20  
electrode_list{6} = {O1 PO4}; %22
electrode_list{7} = {C2 Cz}; %23 
electrode_list{8} = {Cz Pz PO3 PO4 C2}; %24
electrode_list{9} = {PO7 O1 P9}; %25
electrode_list{10} = {C2 Cz}; %26
electrode_list{11} = {C2 Cz O1}; %27
electrode_list{12} = {P4 Cz C2}; %28 
electrode_list{13} = {C2 Cz}; %29 
electrode_list{14} = {C2 Cz C4}; %30
electrode_list{15} = {C2 C3 Cz PO3 CP6 P4}; %31
electrode_list{16} = {C4 Oz F3}; %32 
electrode_list{17} = {Oz Cz C2}; %33
electrode_list{18} = {}; %34
electrode_list{19} = {C2 Cz P3}; %35
electrode_list{20} = {}; %36
electrode_list{21} = {C2 P4}; %37
electrode_list{22} = {C4 Cz C2}; %38
electrode_list{23} = {}; %39
electrode_list{24} = {F8 C4 CP6}; %40
electrode_list{25} = {CP5 C2 Cz}; %41
electrode_list{26} = {PO4 TP7 C2}; %42
electrode_list{27} = {}; %43
electrode_list{28} = {O1}; %44
electrode_list{29} = {PO7}; %45
electrode_list{30} = {}; %46
electrode_list{31} = {C2 Cz PO3 PO4 Pz}; %47
electrode_list{32} = {C2 PO8}; %48
electrode_list{33} = {Cz P4 O2 C4 FC6 C2 PO8}; %49
electrode_list{34} = {}; %50
electrode_list{35} = {PO3 Fz}; %51
electrode_list{36} = {}; %53
electrode_list{38} = {Fp2 PO3}; %55
electrode_list{39} = {}; %56

electrode_list = electrode_list';

filePathSave = %Path to save data, create a condition specific folder

for i=1:N
    
    j = SubjectNum(i);
    
    fileName_interpchans = sprintf('NEST_%d_notch_segmented_badchaninterp.set',j);
    setName_interpchans = sprintf('NEST_%d_notch_badchaninterp',j);
    
    OUTEEG(i) = pop_interp(ALLEEG(i), cell2mat(electrode_list{i,1}), 'spherical');
    
    OUTEEG(i).setname = setName_interpchans;
    OUTEEG(i).filename = fileName_interpchans;
    OUTEEG(i).filepath = filePathSave; 
   
    EEG = pop_saveset( OUTEEG(i), 'filename',fileName_interpchans,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );

end

%% Interpolate bad electrodes: RG condition
% Define subject-specific bad electrode lists for the RG condition.
% Interpolate identified bad electrodes using spherical interpolation.
% Save the resulting datasets with interpolated channels.

 electrode_list = {};
 electrode_list{1}={Oz P4 PO3}; %NEST_16
 electrode_list{2} = {Pz C2 PO4 PO3 }; %NEST_17
 electrode_list{3} = {}; %18
 electrode_list{4} = {Cz Pz PO3 C2 PO4 C3}; %19
 electrode_list{5} = {}; %20  
 electrode_list{6} = {}; %22
 electrode_list{7} = {C2 Cz}; %23 
 electrode_list{8} = {Cz Pz PO3 PO4 C2}; %24
 electrode_list{9} = {PO7 P9}; %25
 % electrode_list{10} = {C2 Cz}; %26
 electrode_list{11} = {C2 Cz O1 PO7}; %27
 electrode_list{12} = {P4 Cz C2}; %28 
 electrode_list{13} = {C2 Cz P9}; %29 
 electrode_list{14} = {C2 Cz C4}; %30
 electrode_list{15} = {C2 C3 Cz CP6 P4}; %31
 electrode_list{16} = {Oz F3 PO3}; %32 
 electrode_list{17} = {Oz Cz C2}; %33
 electrode_list{18} = {C2}; %34
 electrode_list{19} = {C2 Cz}; %35
 electrode_list{20} = {}; %36
 electrode_list{21} = {C2 P4}; %37
 electrode_list{22} = {C4 Cz C2}; %38
 electrode_list{23} = {}; %39
 electrode_list{24} = {F8 C4}; 
 electrode_list{25} = {CP5 C2 Cz Fz}; %41
 electrode_list{26} = {PO4 TP7 C2 Cz}; %42
 electrode_list{27} = {}; %43
 electrode_list{28} = {O1 PO3}; %44
 electrode_list{29} = {PO7 O1}; %45
 electrode_list{30} = {}; %46
 electrode_list{31} = {C2 PO3 PO4 Pz}; %47
 electrode_list{32} = {}; %48
 % electrode_list{33} = {}; %49
 % electrode_list{34} = {}; %50
 % electrode_list{35} = {PO3 Fz}; %51
 electrode_list{33} = {PO3 Fz}; %52
 electrode_list{34} = {PO3}; %54
 % electrode_list{36} = {}; %53
 electrode_list{35} = {C4 PO3}; %55
 % electrode_list{39} = {}; %56

 electrode_list = electrode_list';

 filePathSave = %Path to save data, create a condition specific folder


 for i=1:N
    
    j = SubjectNum(i);
    
    fileName_interpchans = sprintf('NEST_%d_notch_segmented_badchaninterp.set',j);
    setName_interpchans = sprintf('NEST_%d_notch_badchaninterp',j);
    
    OUTEEG(i) = pop_interp(ALLEEG(i), cell2mat(electrode_list{i,1}), 'spherical');
    
    OUTEEG(i).setname = setName_interpchans;
    OUTEEG(i).filename = fileName_interpchans;
    OUTEEG(i).filepath = filePathSave; 
   
    EEG = pop_saveset( OUTEEG(i), 'filename',fileName_interpchans,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );

end

%% Interpolate bad electrodes: LC condition
% Define subject-specific bad electrode lists for the LC condition.
% Interpolate identified bad electrodes using spherical interpolation.
% Save the resulting datasets with interpolated channels.

 electrode_list = {};
 electrode_list{1}={Oz}; %NEST_16
 electrode_list{2} = {Cz C2 PO4 PO3 }; %NEST_17
 electrode_list{3} = {}; %18
 electrode_list{4} = {Cz Pz PO3 C2 PO4 C3}; %19
 electrode_list{5} = {C2}; %20  
 electrode_list{6} = {O1}; %22
 electrode_list{7} = {}; %23 
 electrode_list{8} = {Cz Pz PO3 PO4 C2}; %24
 % electrode_list{9} = {PO7 P9}; %25
 % electrode_list{10} = {C2 Cz}; %26
 electrode_list{11} = {C2 Cz O1}; %27
 electrode_list{12} = {P4 Cz C2 O1}; %28 
 electrode_list{13} = {C2 Cz P9 C3}; %29 
 electrode_list{14} = {C2 Cz C4}; %30
 electrode_list{15} = {C2 C3 Cz CP6 P4}; %31
 electrode_list{16} = {Oz F3 PO3}; %32 
 electrode_list{17} = {Oz Cz C2}; %33
 electrode_list{18} = {C2}; %34
 electrode_list{19} = {C2 Cz}; %35
 electrode_list{20} = {}; %36
 electrode_list{21} = {C2 P4}; %37
 electrode_list{22} = {C4 Cz C2 Oz}; %38
 electrode_list{23} = {}; %39
 electrode_list{24} = {C4}; 
 electrode_list{25} = {CP5 C2 Cz Fz}; %41
 electrode_list{26} = {PO4 TP7 C2 Cz}; %42
 electrode_list{27} = {C2 P4}; %43
 % electrode_list{28} = {O1 PO3}; %44
 electrode_list{29} = {PO7 O1}; %45
 electrode_list{30} = {}; %46
 electrode_list{31} = {C2 PO3 PO4 Pz}; %47
 electrode_list{32} = {C2}; %48
 % electrode_list{33} = {}; %49
 % electrode_list{34} = {}; %50
 electrode_list{35} = {PO3 Fz}; %51
 electrode_list{33} = {}; %52
 %  electrode_list{34} = {PO3}; %53
 electrode_list{36} = {}; %54
 electrode_list{35} = {C4 PO3}; %55
 % electrode_list{39} = {}; %56

 electrode_list = electrode_list';

 filePathSave = %Path to save data, create a condition specific folder


 for i=1:N
    
    j = SubjectNum(i);
    
    fileName_interpchans = sprintf('NEST_%d_notch_segmented_badchaninterp.set',j);
    setName_interpchans = sprintf('NEST_%d_notch_badchaninterp',j);
    
    OUTEEG(i) = pop_interp(ALLEEG(i), cell2mat(electrode_list{i,1}), 'spherical');
    
    OUTEEG(i).setname = setName_interpchans;
    OUTEEG(i).filename = fileName_interpchans;
    OUTEEG(i).filepath = filePathSave; 
   
    EEG = pop_saveset( OUTEEG(i), 'filename',fileName_interpchans,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );

end

%% Interpolate bad electrodes: HC condition
% Define subject-specific bad electrode lists for the HC condition.
% Interpolate identified bad electrodes using spherical interpolation.
% Save the resulting datasets with interpolated channels.

 electrode_list = {};
 electrode_list{1}={}; %NEST_16
 electrode_list{2} = {Pz C2 PO4 PO3 }; %NEST_17
 electrode_list{3} = {}; %18
 electrode_list{4} = {Cz Pz PO3 C2 PO4 C3 C2}; %19
 electrode_list{5} = {}; %20  
 electrode_list{6} = {O1}; %22
 electrode_list{7} = {C2 Cz}; %23 
 electrode_list{8} = {Cz Pz PO3 PO4 C2}; %24
 electrode_list{9} = {PO7 P9 C2}; %25
 % electrode_list{10} = {C2 Cz}; %26
 % electrode_list{11} = {C2 Cz O1}; %27
 electrode_list{12} = {P4 Cz C2 O1}; %28 
 % electrode_list{13} = {C2 Cz P9 C3}; %29 
 electrode_list{14} = {C2 Cz C4}; %30
 electrode_list{15} = {C2 C3 Cz CP6}; %31
 % electrode_list{16} = {Oz F3 PO3}; %32 
 % electrode_list{17} = {Oz Cz C2}; %33
 electrode_list{18} = {C2}; %34
 electrode_list{19} = {C2 Cz}; %35
 electrode_list{20} = {}; %36
 % electrode_list{21} = {C2 P4}; %37
 electrode_list{22} = {C4 Cz C2 Oz}; %38
 electrode_list{23} = {}; %39
 electrode_list{24} = {C4}; 
 electrode_list{25} = {CP5 C2 Cz Fz}; %41
 electrode_list{26} = {PO4 TP7 C2 Cz}; %42
 electrode_list{27} = {}; %43
 electrode_list{28} = {O1}; %44
 electrode_list{29} = {PO7 O1}; %45
 electrode_list{30} = {}; %46
 electrode_list{31} = {C2 PO3 PO4 Pz}; %47
 electrode_list{32} = {C2}; %48
 electrode_list{33} = { FC6 C4 C2 PO8}; %49
 % electrode_list{34} = {}; %50
 electrode_list{35} = {PO3 Fz}; %51
 electrode_list{33} = {}; %52
 % electrode_list{34} = {PO3}; %53
 electrode_list{36} = {}; %54
 electrode_list{35} = {C4 PO3}; %55
 % electrode_list{39} = {}; %56

 electrode_list = electrode_list';

 filePathSave = %Path to save data, create a condition specific folder

 for i=1:N
    
    j = SubjectNum(i);
    
    fileName_interpchans = sprintf('NEST_%d_notch_segmented_badchaninterp.set',j);
    setName_interpchans = sprintf('NEST_%d_notch_badchaninterp',j);
    
    OUTEEG(i) = pop_interp(ALLEEG(i), cell2mat(electrode_list{i,1}), 'spherical');
    
    OUTEEG(i).setname = setName_interpchans;
    OUTEEG(i).filename = fileName_interpchans;
    OUTEEG(i).filepath = filePathSave; 
   
    EEG = pop_saveset( OUTEEG(i), 'filename',fileName_interpchans,'filepath',filePathSave);
    EEG = eeg_checkset( EEG );

end
