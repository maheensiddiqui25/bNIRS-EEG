
%load('bNIRSDATA.mat')
%load('EEGDATA.mat')

bNIRS = bNIRS_DATA; %your bNIRS data
r = EEG_DATA; %your EEG data
%% ============================================================
% bNIRS + EEG figure
%% ============================================================

freqs = {'Theta','Alpha','Beta','Gamma'};

chanNums = [1 2 3 4 5 9 11:18];

lims(1,:) = [-0.5 0.5];
lims(2,:) = [-0.5 0.5];
lims(3,:) = [-0.5 0.5];
lims(4,:) = [-0.1 0.1];
%k1 = [1 4 9];
for k = 1:N %N is number of subjects
    %k = k1(k2);
    figure('Color','w','Position',[100 100 1700 750]);

    %% ========================================================
    % bNIRS plots
    %% ========================================================

    for ch = 1:14 %valid bNIRS channels 

subplot(2,8,ch)

%% Left axis (HbO & HHb)

yyaxis left

plot(bNIRS(:,1,ch,k),'r-','LineWidth',2);
hold on
plot(bNIRS(:,2,ch,k),'b-','LineWidth',2);

ylim([-0.5 0.5])
xlim([5 size(bNIRS,1)])

line([5 5],[-1 1],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',1.5);

line([13 13],[-1 1],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',1.5);

%% Right axis (oxCCO)

yyaxis right

plot(bNIRS(:,3,ch,k),'g-','LineWidth',2);

ylim([-0.2 0.2])
xlim([5 size(bNIRS,1)])

%% Formatting

title(sprintf('Channel %d',chanNums(ch)),...
    'FontWeight','bold',...
    'FontSize',10)

set(gca,...
    'FontSize',12,...
    'LineWidth',1)

box off
    end

    %% ========================================================
    % Reserve subplot 14-16 for EEG
    %% ========================================================

    ax1 = subplot(2,8,14);
    pos1 = get(ax1,'Position');

    ax2 = subplot(2,8,15);
    pos2 = get(ax2,'Position');

    ax3 = subplot(2,8,16);
    pos3 = get(ax3,'Position');

    delete(ax1)
    delete(ax2)
    delete(ax3)

    % Combined rectangle
    left   = pos1(1);
    bottom = pos3(2);
    right  = pos3(1)+pos3(3);
    top    = pos1(2)+pos1(4);

    W = right-left;
    H = top-bottom;

    gap = 0.01;

    w = (W-gap)/2;
    h = (H-gap)/2;

    positions = [
        left         bottom+h+gap   w h      % Theta
        left+w+gap   bottom+h+gap   w h      % Alpha
        left         bottom         w h      % Beta
        left+w+gap   bottom         w h      % Gamma
    ];

    %% ========================================================
    % EEG topoplots
    %% ========================================================

    for i = 1:4

        axes('Position',positions(i,:));

        topoplot(squeeze(r(:,k,i)),A,...
            'gridscale',300,...
            'numcontour',5,...
            'shading','interp',...
            'electrodes','off');

        %caxis(lims(i,:))

        axis off

        title(freqs{i},...
            'FontWeight','bold',...
            'FontSize',11)

    end

end

%%


freqs = {'Theta','Alpha','Beta','Gamma'};

chanNums = [1 2 3 4 5 9 11:18];

lims(1,:) = [-0.8 0.8];
lims(2,:) = [-0.5 0.5];
lims(3,:) = [-0.3 0.3];
lims(4,:) = [-0.1 0.1];

for k = XX %XX is the individual subjects
    %k = k1(k2);
    figure('Color','w','Position',[100 100 1700 750]);

    % ========================================================
    % bNIRS plots
    % ========================================================

    for ch = 1:13

subplot(2,8,ch)

% Left axis (HbO & HHb)

yyaxis left

plot(bNIRS(:,1,ch,k),'r-','LineWidth',2);
hold on
plot(bNIRS(:,2,ch,k),'b-','LineWidth',2);

ylim([-1.5 1.5])
xlim([5 size(bNIRS,1)])

line([5 5],[-1.5 1.5],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',1.5);

line([13 13],[-1.5 1.5],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',1.5);

% Right axis (oxCCO)

yyaxis right

plot(bNIRS(:,3,ch,k),'g-','LineWidth',2);

ylim([-0.2 0.2])
xlim([5 size(bNIRS,1)])

% Formatting

title(sprintf('Channel %d',chanNums(ch)),...
    'FontWeight','bold',...
    'FontSize',10)

set(gca,...
    'FontSize',12,...
    'LineWidth',1)

box off
    end

    % ========================================================
    % Reserve subplot 14-16 for EEG
    % ========================================================

    ax1 = subplot(2,8,14);
    pos1 = get(ax1,'Position');

    ax2 = subplot(2,8,15);
    pos2 = get(ax2,'Position');

    ax3 = subplot(2,8,16);
    pos3 = get(ax3,'Position');

    delete(ax1)
    delete(ax2)
    delete(ax3)

    % Combined rectangle
    left   = pos1(1);
    bottom = pos3(2);
    right  = pos3(1)+pos3(3);
    top    = pos1(2)+pos1(4);

    W = right-left;
    H = top-bottom;

    gap = 0.01;

    w = (W-gap)/2;
    h = (H-gap)/2;

    positions = [
        left         bottom+h+gap   w h      % Theta
        left+w+gap   bottom+h+gap   w h      % Alpha
        left         bottom         w h      % Beta
        left+w+gap   bottom         w h      % Gamma
    ];

    % ========================================================
    % EEG topoplots
    % ========================================================

    for i = 1:4

        axes('Position',positions(i,:));

        topoplot(squeeze(r(:,k,i)),A,...
            'gridscale',300,...
            'numcontour',5,...
            'shading','interp',...
            'electrodes','off');

        caxis(lims(i,:))

        axis off

        title(freqs{i},...
            'FontWeight','bold',...
            'FontSize',11)

    end

end


freqs = {'Theta','Alpha','Beta','Gamma'};

chanNums = [1 2 3 4 5 9 11:18];

lims(1,:) = [-0.6 0.6];
lims(2,:) = [-0.4 0.4];
lims(3,:) = [-0.7 0.7];
lims(4,:) = [-0.2 0.2];
%k1 = [1 4 9];
for k = XX %XX is the individual subjects
    %k = k1(k2);
    figure('Color','w','Position',[100 100 1700 750]);

    % ========================================================
    % bNIRS plots
    % ========================================================

    for ch = 1:13

subplot(2,8,ch)

% Left axis (HbO & HHb)

yyaxis left

plot(bNIRS(:,1,ch,k),'r-','LineWidth',2);
hold on
plot(bNIRS(:,2,ch,k),'b-','LineWidth',2);

ylim([-0.8 0.8])
xlim([5 size(bNIRS,1)])

line([5 5],[-0.8 0.8],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',1.5);

line([13 13],[-0.8 0.8],...
    'Color','k',...
    'LineStyle','-',...
    'LineWidth',1.5);

% Right axis (oxCCO)

yyaxis right

plot(bNIRS(:,3,ch,k),'g-','LineWidth',2);

ylim([-0.2 0.2])
xlim([5 size(bNIRS,1)])

% Formatting

title(sprintf('Channel %d',chanNums(ch)),...
    'FontWeight','bold',...
    'FontSize',10)

set(gca,...
    'FontSize',12,...
    'LineWidth',1)

box off
    end

    % ========================================================
    % Reserve subplot 14-16 for EEG
    % ========================================================

    ax1 = subplot(2,8,14);
    pos1 = get(ax1,'Position');

    ax2 = subplot(2,8,15);
    pos2 = get(ax2,'Position');

    ax3 = subplot(2,8,16);
    pos3 = get(ax3,'Position');

    delete(ax1)
    delete(ax2)
    delete(ax3)

    % Combined rectangle
    left   = pos1(1);
    bottom = pos3(2);
    right  = pos3(1)+pos3(3);
    top    = pos1(2)+pos1(4);

    W = right-left;
    H = top-bottom;

    gap = 0.01;

    w = (W-gap)/2;
    h = (H-gap)/2;

    positions = [
        left         bottom+h+gap   w h      % Theta
        left+w+gap   bottom+h+gap   w h      % Alpha
        left         bottom         w h      % Beta
        left+w+gap   bottom         w h      % Gamma
    ];

    % ========================================================
    % EEG topoplots
    % ========================================================

    for i = 1:4

        axes('Position',positions(i,:));

        topoplot(squeeze(r(:,k,i)),A,...
            'gridscale',300,...
            'numcontour',5,...
            'shading','interp',...
            'electrodes','off');

        caxis(lims(i,:))

        axis off

        title(freqs{i},...
            'FontWeight','bold',...
            'FontSize',11)

    end

end