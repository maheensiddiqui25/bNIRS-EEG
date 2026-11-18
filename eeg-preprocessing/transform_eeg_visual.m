

function [Blocks, EEG] = transform_eeg_visual(EEG, cond)

% TRANSFORM_EEG_VISUAL
% Divides continuous EEG data into blocks based on the time intervals
% between consecutive events. Block boundaries are identified using
% condition-specific timing thresholds.
% Original segment indices are retained to preserve the position of each
% segment within the original EEG recording.

% Extract event latencies and calculate the time interval between
% consecutive events

lat = [EEG.event.latency_ms];
tim = diff(lat);

switch cond
    case {1,2}
        blockBreaks = find(tim > 10000);

    case {3,4}
        blockBreaks = find(tim > 4000 & tim < 10000);
end

nSeg = size(EEG.data,3);

% Assign block labels
blockLabel = ones(1,nSeg);
currentBlock = 1;

for i = 2:nSeg
    if any(blockBreaks == i-1)
        currentBlock = currentBlock + 1;
    end
    blockLabel(i) = currentBlock;
end

% Save block labels
for i = 1:nSeg
    EEG.event(i).block = blockLabel(i);
end

% Reconstruct the blocks
nBlocks = max(blockLabel);

Blocks = struct();

for b = 1:nBlocks
    idx = find(blockLabel == b);

    Blocks(b).data = EEG.data(:,:,idx);
    Blocks(b).segments = idx;
    Blocks(b).blockNumber = b;
end