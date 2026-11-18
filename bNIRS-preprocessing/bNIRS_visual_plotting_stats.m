
% Load bNIRS data .mat file, which contains the Avg_NEST structure.
% Each element of Avg_NEST corresponds to one infant. Within each infant,
% each condition contains trial-level data in "avgtot" (time x chromophore
% x channel x trial) and baseline-corrected, trial-averaged data in
% "average_data" (time x chromophore x channel).

% Load data
conds = [3 4 5 6];
for i=1:12
    for k=1:4
        cond = conds(k);
        All_avgs_new(:,:,:,i,k) = Avg_NEST(i).avg(cond).average_data(1:26,:,:);
    end
end

%% Collapse across visual conditions and calculate group averages
% The four visual conditions are combined into two groups:
% P combines the R/G checkerboard and low-contrast grating conditions
% (conditions 3 and 5).
% M combines the B/W checkerboard and high-contrast grating conditions
% (conditions 4 and 6).
%
% Responses are first averaged across the two conditions within each group,
% retaining individual infant data. The P and M responses are then combined
% to obtain the overall visual response across conditions and infants.

%Collapse R/G checkerboard and low contrast gratings
P = All_avgs_new(:,:,:,:,1);
P(:,:,:,:,2) = All_avgs_new(:,:,:,:,3);

%Collapse B/W checkerboard and high contrast gratings
M = All_avgs_new(:,:,:,:,2);
M(:,:,:,:,2) = All_avgs_new(:,:,:,:,4);

P_avg = squeeze(nanmean(P,5)); %averaged across the 2 conditions, all subjects
P_avg2 = squeeze(nanmean(P_avg,4)); %averaged across the 2 conditions, averaged across subjects

M_avg = squeeze(nanmean(M,5)); %averaged across the 2 conditions, all subjects
M_avg2 = squeeze(nanmean(M_avg,4));%averaged across the 2 conditions, averaged across subjects

Vis_M_P(:,:,:,:,1) = P_avg;
Vis_M_P(:,:,:,:,2) = M_avg;

Vis_M_P_2 = squeeze(nanmean(Vis_M_P,4)); 

Vis_M_P_2_avg = squeeze(nanmean(Vis_M_P_2,4));
All_avgs_new2 = squeeze(nanmean(All_avgs_new,5));


%% Plot group-average responses across channels
% Plot the group-average oxy, deoxy and cyt responses for the selected
% occipital and temporal channels. The number of infants contributing data
% to each channel is displayed in the subplot title.
% 
chans = [1 2 3 4 5 11:18];
figure;
    for j=1:13
        ch=chans(j);
        subplot(2,7,j);
        hold on;
        yyaxis left
       % ylim([-ylim_min_left ylim_max_left]) 
        ylim([-0.4 0.4]) 
        plot(Vis_M_P_2_avg(:,1,ch),'r-','LineWidth',2); 
        hold on;
        plot(Vis_M_P_2_avg(:,2,ch),'b-','LineWidth',2); 
        line([5 5],[-0.4 0.4],'LineWidth',1,'Color','k','LineStyle','-');
        line([13 13],[-0.6 0.6],'LineWidth',1,'Color','k','LineStyle','-');
        yyaxis right
        xlim([3 26]);
        ylim([-0.1 0.1]) 
        plot(Vis_M_P_2_avg(:,3,ch),'g-','LineWidth',2); 
        title(sprintf('Ch %d'); 
        set(gca,'FontSize',15)
    end


%% Calculate standard deviations across infants
% Calculate the standard deviation of the P and M responses across infants
% for each time point, chromophore and channel. These values are used to
% illustrate variability in the infant responses in the following plots. 

for i=1:19
    std_vis_M_P(:,:,i,:) = nanstd(Vis_M_P(:,:,i,:),0,4);
end

%% Plot response variability for each chromophore
% Plot the group-average time courses with standard deviation error bars
% for each selected channel, separately for oxy, deoxy and cyt.
% Channel 9 is excluded from these plots.

std_vis_M_P(:,:,9) = NaN;
Vis_M_P_2_avg(:,:,9) = NaN;
conds = {'All visual'};
mycolormap = [1 0 0; 0 0 1; 0 1 0];
chans = [1 2 3 4 5 11:18];
    for chrom = 1:2
       figure;
            for i=1:13
                ch = chans(i); 
                subplot(2,7,i); 
                hold on
                errorbar(squeeze(Vis_M_P_2_avg(:,chrom,ch)),std_vis_M_P(:,chrom,ch),'x','Color',mycolormap(chrom,:));
                line(xlim(), [0,0], 'LineWidth', 2, 'Color', 'k');
                ylim([-1 1]) 
            title(sprintf('Channel %d, n=%d',ch,ALL_no_of_subs(i))); 
            end
    end
    figure;
    chrom = 3;
            for i=1:13
                ch = chans(i); 
                subplot(2,7,i); 
                hold on
                errorbar(squeeze(Vis_M_P_2_avg(:,chrom,ch)),std_vis_M_P(:,chrom,ch),'x','Color',mycolormap(chrom,:));
                line(xlim(), [0,0], 'LineWidth', 2, 'Color', 'k');
                ylim([-0.2 0.2]) 
                        title(sprintf('Channel %d, n=%d',ch,ALL_no_of_subs(i))); 

            end

%% Extract mean responses within the 14–18 s post-stimulus time window
% Select the occipital and temporal channels and calculate the mean
% response between 14 and 18 s after stimulus onset for each infant.
% This produces one mean value per infant, channel and chromophore
% (oxy, deoxy and cyt), which is used in the subsequent statistical tests.

All_avgs_new3 = All_avgs_new2(:,:,[1 2 3 4 5 11:18],:);
t1=14:18;
        for i=1:12
            for j=1:13
                MeanValMat_t1_all(1,j,i) = mean(((All_avgs_new3(t1,1,j,i))),1); 
                MeanValMat_t1_all(2,j,i) = mean(((All_avgs_new3(t1,2,j,i))),1);
                MeanValMat_t1_all(3,j,i) = mean(((All_avgs_new3(t1,3,j,i))),1);  
            end
        end

  
%% Statistical analysis of mean responses in the 14–18 s window
% Perform separate one-sample t-tests against zero for oxy, deoxy and cyt
% at each of the 13 selected channels. Each test uses the individual
% infants' mean response values within the 14–18 s post-stimulus window.
% Store the resulting p-values, significance indicators and t-statistics
% for each chromophore and channel.

%for chrom=1:3
        for j=1:13
           [h_t1_M_P_oxy(j,:),p_t1_M_P_oxy(j,:),~,stats_oxy.tstat] = ttest(MeanValMat_t1_all(1,j,:),0,0.05,0);
           [h_t1_M_P_deoxy(j,:),p_t1_M_P_deoxy(j,:),~,stats_deoxy.tstat] = ttest(MeanValMat_t1_all(2,j,:),0,0.05,0);
           [h_t1_M_P_cyt(j,:),p_t1_M_P_cyt(j,:),~,stats_cyt.tstat] = ttest(MeanValMat_t1_all(3,j,:),0,0.05,0);
                    
           tval_oxy_M_P(j) = stats_oxy.tstat.tstat;
           tval_deoxy_M_P(j) = stats_deoxy.tstat.tstat;
           tval_cyt_M_P(j) = stats_cyt.tstat.tstat;
        end
%end


%%
        %for chrom=1:3
%for i=1:18
    FDR_oxy_t1 = mafdr((p_t1_M_P_oxy),'BHFDR',true);
    FDR_deoxy_t1 = mafdr((p_t1_M_P_deoxy),'BHFDR',true);
    FDR_cyt_t1 = mafdr(p_t1_M_P_cyt,'BHFDR',true);

%end
        %end
    
