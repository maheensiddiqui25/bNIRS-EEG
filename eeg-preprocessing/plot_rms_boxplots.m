%% ============================================================
% Posterior EEG variability across infants
%
% r = channel x infant x frequency band
%
% No averaging across channels.
%
% ============================================================

freqs = {'Theta','Alpha','Beta','Gamma'};


%% ------------------------------------------------------------
% Posterior channel labels
% ------------------------------------------------------------

posterior_labels = {'O1','Oz','O2','PO3','PO4','Pz'};

%% ------------------------------------------------------------
% Find channel numbers from A
% ------------------------------------------------------------

labels = {A.labels};

posterior_channels = find(ismember(labels,posterior_labels));

posterior_names = labels(posterior_channels);


%% ------------------------------------------------------------
% Plot
% ------------------------------------------------------------

figure('Color','w',...
    'Position',[100 100 1400 800]);


for band = 1:4

    subplot(2,2,band);

    % Extract posterior channels x infants
    data = squeeze(r(posterior_channels,:,band));


    %% --------------------------------------------------------
    % Boxplot
    %% --------------------------------------------------------

    boxplot(data',...
        'Labels',posterior_names,...
        'Symbol','',...
        'Widths',0.6);

    hold on;


    %% --------------------------------------------------------
    % Make boxplot lines thicker
    %% --------------------------------------------------------

    h = findobj(gca,'Tag','Box');
    set(h,'LineWidth',2);

    h = findobj(gca,'Tag','Median');
    set(h,'LineWidth',2);

    h = findobj(gca,'Tag','Whisker');
    set(h,'LineWidth',2);

    h = findobj(gca,'Tag','Cap');
    set(h,'LineWidth',2);


    %% --------------------------------------------------------
    % Individual infant values
    %% --------------------------------------------------------

    for ch = 1:length(posterior_channels)

        y = data(ch,:);

        % Remove NaNs
        valid = ~isnan(y);
        y = y(valid);

        % Horizontal jitter
        x = ch + (rand(size(y))-0.5)*0.25;

        scatter(x,y,...
            65,...
            'k',...
            'filled',...
            'MarkerFaceAlpha',1,...
            'MarkerEdgeColor','k',...
            'LineWidth',0.5);

    end


    %% --------------------------------------------------------
    % Strong zero line
    %% --------------------------------------------------------

    yline(0,...
        'k-',...
        'LineWidth',2);


    %% --------------------------------------------------------
    % Formatting
    %% --------------------------------------------------------

    title(freqs{band},...
        'FontSize',18,...
        'FontWeight','bold');

    ylabel('RMS power',...
        'FontSize',14);

    xtickangle(45);

    box off;

    set(gca,...
        'FontSize',12,...
        'LineWidth',1.5);

end