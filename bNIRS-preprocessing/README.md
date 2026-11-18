# Broadband NIRS MATLAB analysis code

This repository contains MATLAB scripts and lookup tables used for processing broadband spectroscopy data. The files cover detector-data segmentation and source assignment, attenuation and chromophore-concentration calculations, channel quality screening, event-locked averaging, and supporting optical-property lookup tables.

## Contents

| File | Description |
|---|---|
| `NEST_analysis2018.m` | Main NEST processing workflow. Loads detector, timing and serial-capture data; reconstructs event timing; segments and sorts detector signals; calculates chromophore concentration changes; interpolates and filters the data; and produces channel plots. |
| `V_BBS_Segmenting.m` | Loads broadband spectroscopy detector data, appends timing information, separates detector blocks, and splits alternating measurements into acquisition phases. |
| `V_BBS_Sorting.m` | Assigns alternating detector measurements to four source groups using the acquisition sequence and loads wavelength calibration vectors. |
| `V_BBS_MBL.m` | Calculates attenuation and haemoglobin / oxidised cytochrome-c-oxidase concentration changes from broadband spectroscopy intensity data, including wavelet motion correction. |
| `Channel_Reject.m` | Screens channels using maximum detector intensity and oxy-/deoxy-haemoglobin signal correlation. |
| `average_NEST.m` | Extracts event-locked epochs, averages trials by condition, applies baseline correction and detrending, and plots channel responses. |
| `hmrMotionArtifactByChannel.m` | Detects motion artefacts on active measurement channels and returns overall and channel-specific inclusion vectors. |
| `abscoeff.m` | Legacy broadband NIRS extinction-coefficient lookup table. |
| `tissue_specific_extinction_coefficient_650to1000.m` | Tissue-specific extinction-coefficient lookup table covering 650–1000 nm. |
| `water_specific_extinction_spectrum_37Celcius.m` | Water-specific extinction spectrum measured at 37 °C. |
| `DPF_Lambda_Dependency_740to915.m` | Wavelength-dependent differential pathlength factor lookup table covering 740–915 nm. |
| `colorpalette.m` | Named RGB colour definitions and optional palette visualisations. |

## Processing overview

The main workflow in `NEST_analysis2018.m` is intended to call the segmentation, sorting and broadband spectroscopy processing functions, then assemble and filter the channel-level concentration data. `Channel_Reject.m` performs channel screening, while `average_NEST.m` provides event-related averaging and visualisation.

The optical-property functions provide lookup tables used by the broadband spectroscopy calculations. `hmrMotionArtifactByChannel.m` is a separate channel-wise motion-artifact detection function.

## Requirements and inputs

- MATLAB.
- The Signal Processing Toolbox for the `butter` and `filtfilt` functions used in the main workflow.
- The Statistics and Machine Learning Toolbox 
- The external function `hmrMotionCorrectWavelet`, which is called by `V_BBS_MBL.m` 
- Input detector-intensity files, timing files, serial-capture files, and wavelength reference files in the formats expected by the scripts.

The main script currently contains dataset-specific subject and file settings and uses a local data-directory path. These settings have been retained as supplied; update them for a different dataset before running. The analysis scripts also expect intermediate variables to be available in the MATLAB workspace, so run the workflow in the intended order and ensure the input files and required functions are on the MATLAB path.

## Notes on this cleaned code release

Some filenames and comments reflect the original project naming and have been retained for compatibility. The code should be tested with the intended data and MATLAB environment before reuse.

## Citation and reuse

Please cite the associated Wellcome Open Research article and this repository's archived DOI. 