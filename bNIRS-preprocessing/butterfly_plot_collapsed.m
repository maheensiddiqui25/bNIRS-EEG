%% ============================================================
% Figure 8: bNIRS butterfly plots
%
% Load the averaged bNIRS data, combine the relevant experimental
% conditions, and generate butterfly plots showing the time courses
% of HbO2, HHb and oxCCO across the selected occipital and temporal
% channels.
%
% The plots show individual channel responses alongside the average
% response across the selected channels.
%
% ============================================================

%% ============================================================
% Load bNIRS data
% ============================================================

% Load Avg_NEST.mat, which contains the processed bNIRS data for
% all infants.
%
% Avg_NEST is a structure in which each element corresponds to an
% individual infant.
%
% Within each infant:
%   avg(cond).avgtot:
%       Contains trial-level data organised as:
%       time x chromophore x channel x trial.
%
%   avg(cond).average_data:
%       Contains baseline-corrected data averaged across trials,
%       organised as:
%       time x chromophore x channel.
%
% The analysis below uses average_data.

load('Avg_NEST.mat')

%% ============================================================
% Extract data for the conditions of interest
% ============================================================

% Identify the four condition indices to be included.
%
% These are subsequently grouped into two broader condition
% categories:
%   P: conditions 3 and 5
%   M: conditions 4 and 6

conds = [3 4 5 6];

% Extract the baseline-corrected, trial-averaged data for each
% infant and condition.
%
% Only the first 26 time points are retained.
%
% Resulting array:
%   time x chromophore x channel x infant x condition

for i=1:12
    for k=1:4
        cond = conds(k);
        All_avgs_new(:,:,:,i,k) = Avg_NEST(i).avg(cond).average_data(1:26,:,:);
    end
end

%% ============================================================
% Combine conditions into P and M groups
% ============================================================

% Combine the two conditions belonging to the P group:
%   Condition 3
%   Condition 5
%
% The two conditions are retained in the fifth dimension at this
% stage.

P = All_avgs_new(:,:,:,:,1);
P(:,:,:,:,2) = All_avgs_new(:,:,:,:,3);

% Combine the two conditions belonging to the M group:
%   Condition 4
%   Condition 6

M = All_avgs_new(:,:,:,:,2);
M(:,:,:,:,2) = All_avgs_new(:,:,:,:,4);

%% ============================================================
% Average across conditions and infants
% ============================================================

% Average across the two conditions within the P group.
% The fifth dimension represents the two conditions.
%
% P_avg:
%   time x chromophore x channel x infant

P_avg = squeeze(nanmean(P,5)); %averaged across the 2 conditions, all subjects

% Average the P group across infants.
%
% P_avg2:
%   time x chromophore x channel
P_avg2 = squeeze(nanmean(P_avg,4)); %averaged across the 2 conditions, averaged across subjects

% Average across the two conditions within the M group.

M_avg = squeeze(nanmean(M,5)); %averaged across the 2 conditions, all subjects

% Average the M group across infants.
M_avg2 = squeeze(nanmean(M_avg,4));%averaged across the 2 conditions, averaged across subjects


%% ============================================================
% Combine P and M group data
% ============================================================

% Store the P and M group averages in a common array.
%
% Fourth dimension:
%   1 = P group
%   2 = M group
%
% At this stage, the data are organised as:
%   time x chromophore x channel x infant x group
Vis_M_P(:,:,:,:,1) = P_avg;
Vis_M_P(:,:,:,:,2) = M_avg;

Vis_M_P_2 = squeeze(nanmean(Vis_M_P,4)); 

Vis_M_P_2_avg = squeeze(nanmean(Vis_M_P_2,4));

%% ============================================================
% Separate occipital and temporal channels
% ============================================================

% Extract the occipital channels (channels 1–5) and temporal channels (11-18) from the averaged
% data.


Vis_M_P_vis(:,:,:,:) = squeeze(Vis_M_P_2_avg(:,:,[1 2 3 4 5]));
Vis_M_P_temp = squeeze(Vis_M_P_2_avg(:,:,[11 12 13 14 15 16 17 18]));

Vis_M_P_vis_avgchans = squeeze(nanmean(Vis_M_P_vis,3));
Vis_M_P_temp_avgchans = squeeze(nanmean(Vis_M_P_temp,3));

Vis_M_P_avgchans(:,:,:,1) = Vis_M_P_vis_avgchans;
Vis_M_P_avgchans(:,:,:,2) = Vis_M_P_temp_avgchans;

%Vis_M_P_vis(:,:,7:8,:) = NaN;

% % % 
% % % Vis_M_P_3(:,:,:,:,1) = Vis_M_P_vis;
% % % Vis_M_P_3(:,:,:,:,2) = Vis_M_P_temp;


%% ============================================================
% Figure 8: Occipital channel butterfly plots
%
% Plot the time courses for HbO2, HHb and oxCCO across the selected
% occipital channels.
%
% Individual channel responses are plotted using thinner lines.
% The average response across the selected channels is overlaid
% using a thicker line.
% ============================================================

% Labels for the channel groups and chromophores.
labels = {'P occ chans';'M occ chans';'P temp chans';'M temp chans'};
chrom = {'\DeltaHbO_2'; '\DeltaHHb'; '\DeltaoxCCO'};
     col = [1 0 0;0 0 1;0 1 0];
     col2 = [0.7569    0.3529    0.3882;0.3843    0.4784    0.6157; 0.6157    0.6588    0.2510];
     lim = [0.4 0.4 0.06]; 
     ticks = [0.1 0.1 0.02];
Ch_list =[1 2 3 4 5 9 11:18];%[11 12 13 16 17 19 14 15 18];
figure;
for k1=1:3%9
    
    subplot(1,3,k1)
    for i=1:5
        %k=i;%Ch_list(i);
        hold on;
        %line([ 5 5],[-ticks(m) ticks(m)],'LineWidth',3,'Color','k' )
        line([ 0 30],[0  0],'LineWidth',2.5,'Color','k' )
 
        %yyaxis left
        ylim([-lim(k1) lim(k1)]);
        %plot(Avg_NEST_allcondns_new(i).avg(2).average_data(:,m,k ),'color',col2(m,:),'LineWidth',2);  
        plot(Vis_M_P_vis(:,k1,i),'color',col2(k1,:),'LineWidth',2);  
        plot(Vis_M_P_vis_avgchans(:,k1),'color',col(k1,:),'LineWidth',5); 
        
        %%%%%%%title(['', num2str(chrom{k1})]); 
%         title(sprintf(' %s',labels{m,:}));
        set(gca,'XTick',[5 15 25 35], 'XTickLabel',{'5','10','20','30'});
        xlim([5 30]); 
        set(gca,'YTick',[-lim(k1):ticks(k1):lim(k1)]);
        plt = gca;
%        plt.YAxis(2).Color = [0 0.5 0]; % change color of RHS y-axis to black
set(gca,'FontSize',20) 
if k1==1
    ylabel('Concentration Change (\muMol)','FontSize',30,'FontWeight','bold','Color','k');
 
end
if k1==2
     xlabel('Time (s)','FontSize',30,'FontWeight','bold' );
end 
    end
    
end 

%%
labels = {'P occ chans';'M occ chans';'P temp chans';'M temp chans'};
chrom = {'\DeltaHbO_2'; '\DeltaHHb'; '\DeltaoxCCO'};
     col = [1 0 0;0 0 1;0 1 0];
     col2 = [0.7569    0.3529    0.3882;0.3843    0.4784    0.6157; 0.6157    0.6588    0.2510];
     lim = [0.4 0.4 0.06]; 
     ticks = [0.1 0.1 0.02];
Ch_list =[1 2 3 4 5 9 11:18];%[11 12 13 16 17 19 14 15 18];
figure;
for k1=1:3%9
    
    subplot(1,3,k1)
    for i=1:5
        %k=i;%Ch_list(i);
        hold on;
        %line([ 5 5],[-ticks(m) ticks(m)],'LineWidth',3,'Color','k' )
        line([ 0 30],[0  0],'LineWidth',2.5,'Color','k' )
 
        %yyaxis left
        ylim([-lim(k1) lim(k1)]);
        %plot(Avg_NEST_allcondns_new(i).avg(2).average_data(:,m,k ),'color',col2(m,:),'LineWidth',2);  
        plot(Vis_M_P_temp(:,k1,i),'color',col2(k1,:),'LineWidth',2);  
        plot(Vis_M_P_temp_avgchans(:,k1),'color',col(k1,:),'LineWidth',5); 
        
        %%%%%%%title(['', num2str(chrom{k1})]); 
%         title(sprintf(' %s',labels{m,:}));
        set(gca,'XTick',[5 15 25 35], 'XTickLabel',{'5','10','20','30'});
        xlim([5 30]); 
        set(gca,'YTick',[-lim(k1):ticks(k1):lim(k1)]);
        plt = gca;
%        plt.YAxis(2).Color = [0 0.5 0]; % change color of RHS y-axis to black
set(gca,'FontSize',20) 
if k1==1
    ylabel('Concentration Change (\muMol)','FontSize',30,'FontWeight','bold','Color','k');
 
end
if k1==2
     xlabel('Time (s)','FontSize',30,'FontWeight','bold' );
end 
    end
    
end 
