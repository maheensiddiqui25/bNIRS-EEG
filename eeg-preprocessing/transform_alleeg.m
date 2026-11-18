%% Transform EEG data for each condition and subject
% Processes EEG data separately for each of the four visual conditions.
% For each subject, the EEG data are transformed into blocks while
% preserving the original position of each event in the recording.

for cond = 1:4

    fprintf('Condition %d\n', cond)

    nSubs = length(All_visual(cond).cond);

    for s = 1:nSubs

        fprintf('   Subject %d of %d\n', s, nSubs)

        EEG = All_visual(cond).cond(s);

        try

            [Blocks, EEG] = transform_eeg_NEST_visual(EEG, cond);

            E(cond).EEG_data_mat(s).Blocks = Blocks;
            E(cond).EEG_data_mat(s).EEG = EEG;
            E(cond).EEG_data_mat(s).Included = true;

        catch ME

            fprintf('      Skipping subject %d (Condition %d): %s\n', ...
                s, cond, ME.message);

            E(cond).EEG_data_mat(s).Blocks = [];
            E(cond).EEG_data_mat(s).EEG = [];
            E(cond).EEG_data_mat(s).Included = false;

            continue

        end

    end

end