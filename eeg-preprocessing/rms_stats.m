%% ============================================================
% EEG RMS statistics
%
% rmsInfant:
% channel x infant x condition x band
%
% Collapse across conditions
% One sample t-tests vs zero
% FDR correction
% Topoplots
% Occipital ROI statistics
%
% ============================================================


clear t_values p_values p_fdr sig_fdr


%% Parameters

alpha = 0.05;

freqs = {'Theta','Alpha','Beta','Gamma','High gamma'};


A = All_visual(1).cond(1).chanlocs;



%% ============================================================
% Collapse across conditions
% ============================================================

% channel x infant x band

rms_collapsed = squeeze(nanmean(rmsInfant,3));


disp(size(rms_collapsed))



%% ============================================================
% One sample t-tests across infants
% ============================================================

nChannels = size(rms_collapsed,1);
nBands = size(rms_collapsed,3);


t_values = NaN(nChannels,nBands);
p_values = NaN(nChannels,nBands);


for band = 1:nBands


    for ch = 1:nChannels


        data = squeeze(rms_collapsed(ch,:,band));


        % remove missing infants

        data = data(~isnan(data));


        if length(data) > 2


            [~,p,~,stats] = ttest(data,0);


            t_values(ch,band) = stats.tstat;

            p_values(ch,band) = p;


        end

    end

end



%% ============================================================
% FDR correction within each frequency band
% ============================================================


p_fdr = NaN(size(p_values));

sig_fdr = false(size(p_values));


for band = 1:nBands


    p = p_values(:,band);


    valid = ~isnan(p);

    p_valid = p(valid);


    % Benjamini-Hochberg

    [p_sorted,sort_idx] = sort(p_valid);


    m = length(p_sorted);


    threshold = (1:m)'/m*alpha;


    significant = p_sorted <= threshold;


    if any(significant)

        crit_p = p_sorted(find(significant,1,'last'));

    else

        crit_p = 0;

    end


    sig = false(size(p));


    sig(valid) = p(valid) <= crit_p;


    sig_fdr(:,band) = sig;


    % Store adjusted p values

    adj = NaN(size(p_valid));


    adj(sort_idx) = p_sorted .* m ./ (1:m)';


    adj(adj>1)=1;


    p_fdr(valid,band)=adj;


end


% % 
% % %% ============================================================
% % % Plot FDR significant t-values
% % % ============================================================
% % 
% % 
% % tlims = [-5 5];
% % 
% % 
% % figure;
% % 
% % 
% % for band = 1:nBands
% % 
% % 
% %     subplot(2,3,band)
% % 
% % 
% %     topo = t_values(:,band);
% % 
% % 
% %     % remove non-significant channels
% % 
% %     topo(~sig_fdr(:,band)) = NaN;
% % 
% % 
% %     topoplot(topo,A,...
% %         'maplimits',tlims,...
% %         'gridscale',300,...
% %         'numcontour',5,...
% %         'shading','interp',...
% %         'electrodes','on');
% % 
% % 
% %     colorbar
% % 
% % 
% %     title(freqs{band})
% % 
% % end
% % 

%% Plot uncorrected significant t-values (p < 0.05)

figure;

for band = 1:nBands

    subplot(2,3,band)


    % Copy t-values
    topo = t_values(:,band);


    % Mask channels that are not significant
    topo(p_values(:,band) > 0.05) = NaN;


    topoplot(topo,A,...
        'maplimits',[-5 5],...
        'gridscale',300,...
        'numcontour',5,...
        'shading','interp',...
        'electrodes','on');


    colorbar

    title(freqs{band})

end

%% ============================================================
% Occipital ROI statistics
%
% O1 = 7
% O2 = 8
% Oz = 20
%
% ============================================================


occ_channels = [7 8 20];


t_occ = NaN(1,nBands);
p_occ = NaN(1,nBands);


for band = 1:nBands


    % channels x infants

    occ_data = squeeze(...
        rms_collapsed(occ_channels,:,band));


    % average O1/O2/Oz

    occ_mean = nanmedian(occ_data,1)';


    % remove missing

    occ_mean = occ_mean(~isnan(occ_mean));


    % one sample t-test

    [~,p,~,stats] = ttest(occ_mean,0);


    t_occ(band)=stats.tstat;

    p_occ(band)=p;


end



% ============================================================
% Display results
% ============================================================


disp('==============================')
disp('Occipital ROI statistics')
disp('==============================')


for band = 1:4

    fprintf('%s: t = %.3f, p = %.5f\n',...
        freqs{band},...
        t_occ(band),...
        p_occ(band));

end