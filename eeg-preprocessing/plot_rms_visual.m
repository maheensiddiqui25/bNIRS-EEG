%% Plot the average power in the 10-18 s period -- THIS IS FIGURE 11 in the paper


%%
A = conditionXX(1).chanlocs; %load channel locations for the topoplot

%define frequency band titles for plots 
freqs = {'Theta'; 'Alpha'; 'Beta'; 'Gamma'};

rms2_conditionXX_grand_avg = squeeze(nanmean(rms2_conditionXX_avg,3)); %this comes from spectral_visual script
r_conditionXX = rms2_conditionXX_grand_avg(:,:,:);
r_conditionXX_avg = squeeze(nanmean(r_conditionXX,1));

%use topoplot to plot
figure;
for i=1:4
    subplot(2,2,i);
        topoplot(squeeze(r_conditionXX_avg(:,i)),A) ;
        colorbar; 
        title(freqs{i}); 
        set(gca, 'XTick', xticks,'YTick', yticks,'XTickLabel', xticklabels, 'YTickLabel', yticklabels,'FontSize',20);     
end

