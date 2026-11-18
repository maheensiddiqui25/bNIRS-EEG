
%%To reproduce Figure 11: Scalp topographies of average EEG power across the block
%
%
% RMS power values are averaged across infants for each electrode,
% separately for four frequency bands: theta, alpha, beta and gamma.
% The resulting topographies illustrate the spatial distribution of
% average EEG power across the scalp for each frequency band.

%% Load channel locations and define frequency bands
% Retrieve electrode locations from the EEG dataset for use in plotting
% the scalp topographies. Define the frequency bands displayed in Figure 11.
%%
A = conditionXX(1).chanlocs; %load channel locations for the topoplot

%define frequency band titles for plots 
freqs = {'Theta'; 'Alpha'; 'Beta'; 'Gamma'};

%% Average RMS power across infants
% The RMS power data are obtained from the spectral_visual script.
% First, average across the relevant time points within the analysis
% period, then calculate the grand average across infants for each
% electrode and frequency band.


rms2_conditionXX_grand_avg = squeeze(nanmean(rms2_conditionXX_avg,3)); %this comes from spectral_visual script
r_conditionXX = rms2_conditionXX_grand_avg(:,:,:);
r_conditionXX_avg = squeeze(nanmean(r_conditionXX,1));

%% Generate scalp topographies for each frequency band
% Use EEGLAB's topoplot function to display the spatial distribution of
% average RMS power across electrodes. Generate a separate topography for
% each frequency band, with a colour scale to represent power values.

%use topoplot to plot

figure;
for i=1:4
    subplot(2,2,i);
        topoplot(squeeze(r_conditionXX_avg(:,i)),A) ;
        colorbar; 
        title(freqs{i}); 
        set(gca, 'XTick', xticks,'YTick', yticks,'XTickLabel', xticklabels, 'YTickLabel', yticklabels,'FontSize',20);     
end

