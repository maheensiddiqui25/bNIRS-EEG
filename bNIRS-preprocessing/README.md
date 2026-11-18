# Broadband NIRS MATLAB analysis code

This repository contains MATLAB scripts used for processing and analysing broadband near-infrared spectroscopy (bNIRS) data from the NEST study. The code covers detector-data segmentation and source assignment, attenuation and chromophore-concentration calculations, channel quality screening, event-locked averaging, statistical analysis and visualisation of chromophore responses, and relative power and relative cost analyses.

The scripts are provided to support reproducibility of the analyses reported in the associated publication. The original study data are not included in this repository and must be requested using a formal data sharing agreement. Data cannot be shared freely due to restrictions involving human data. 

## Contents

| File | Description |
|---|---|
| `NEST_analysis2018.m` | Main NEST processing workflow. Loads detector, timing and serial-capture data; reconstructs event timing; segments and sorts detector signals; calculates chromophore concentration changes; interpolates and filters the data; and produces channel plots. |
| `V_BBS_Segmenting.m` | Loads broadband spectroscopy detector data, appends timing information, separates detector blocks, and splits alternating measurements into acquisition phases. |
| `V_BBS_Sorting.m` | Assigns alternating detector measurements to four source groups using the acquisition sequence and loads wavelength calibration vectors. |
| `V_BBS_MBL.m` | Calculates attenuation and haemoglobin / oxidised cytochrome-c-oxidase concentration changes from broadband spectroscopy intensity data, including wavelet motion correction. |
| `Channel_Reject.m` | Screens channels using maximum detector intensity and oxy-/deoxy-haemoglobin signal correlation. |
| `average_NEST.m` | Extracts event-locked epochs, averages trials by condition, applies baseline correction and detrending, and plots channel responses. |
| `bNIRS_visual_plotting_stats.m` | Main visual analysis script for bNIRS data. Combines visual conditions, calculates group-level chromophore responses, extracts mean responses within the selected time window, performs statistical testing and Benjamini–Hochberg FDR correction, and generates group-level and individual infant plots. |
| `butterfly_plot_collapsed.m` | Combines selected visual conditions and plots group-averaged bNIRS responses across occipital and temporal channels. Includes visualisation of HbO₂, HHb and oxCCO responses. |
| `pos_neg_rPWR_rCST.m` | Separates positive and negative chromophore responses, standardises responses across channels within each infant, calculates relative power (rPWR) and relative cost (rCST), performs statistical testing and FDR correction, and visualises chromophore relationships and derived measures. |
| `hmrMotionArtifactByChannel.m` | Detects motion artefacts on active measurement channels and returns overall and channel-specific inclusion vectors. |
| `abscoeff.m` | Legacy broadband NIRS extinction-coefficient lookup table. |
| `tissue_specific_extinction_coefficient_650to1000.m` | Tissue-specific extinction-coefficient lookup table covering 650–1000 nm. |
| `water_specific_extinction_spectrum_37Celcius.m` | Water-specific extinction spectrum measured at 37 °C. |
| `DPF_Lambda_Dependency_740to915.m` | Wavelength-dependent differential pathlength factor lookup table covering 740–915 nm. |
| `colorpalette.m` | Named RGB colour definitions and optional palette visualisations. |

## Processing overview

The bNIRS analysis is organised into several stages.

### 1. Broadband spectroscopy processing

The main workflow in `NEST_analysis2018.m` calls the segmentation, sorting and broadband spectroscopy processing functions to assemble and process the detector-level data. These steps include reconstructing event timing, assigning measurements to source groups, calculating chromophore concentration changes, and filtering the resulting channel-level data.

`Channel_Reject.m` performs channel quality screening, while `hmrMotionArtifactByChannel.m` provides channel-wise motion-artifact detection.

### 2. Event-locked averaging

`average_NEST.m` extracts event-locked epochs and calculates condition-specific averages. Baseline correction and detrending are applied to the data, and channel-level responses are plotted.

The subsequent analysis scripts use the resulting `Avg_NEST` structure. This contains data for each infant and condition, including:

- `avgtot`: trial-level data organised as time × chromophore × channel × trial.
- `average_data`: baseline-corrected data averaged across trials, organised as time × chromophore × channel.

These data are used for further averaging, visualisation and statistical analysis.

### 3. Group-level and individual infant response analysis

`bNIRS_visual_plotting_stats.m` combines selected visual conditions to calculate group-level chromophore responses. Responses are averaged across conditions and infants, and visualisations are generated for selected occipital and temporal channels.

Individual infant responses are also plotted to allow inspection of variability in chromophore responses across participants.

For the Figure 9 analysis, the mean chromophore response is extracted within the 14–18 s post-stimulus window for each infant and channel. Separate one-sample t-tests are performed for oxyhaemoglobin (HbO₂), deoxyhaemoglobin (HHb) and oxidised cytochrome-c-oxidase (oxCCO), testing whether the mean response differs from zero. Benjamini–Hochberg false discovery rate (FDR) correction is applied to account for multiple channel-wise comparisons.

### 4. Collapsed-condition visualisation

`butterfly_plot_collapsed.m` combines the selected visual conditions and produces group-level plots of HbO₂, HHb and oxCCO responses across selected occipital and temporal channels. The script provides a visual overview of the average chromophore responses across the selected conditions.

### 5. Positive and negative response analysis: relative power and relative cost

`pos_neg_rPWR_rCST.m` separates infant responses into positive and negative response groups based on the direction of the mean chromophore response within the selected time window.

Within each infant, chromophore responses are standardised across channels. Relative power (rPWR) and relative cost (rCST) are then calculated using a 45-degree rotation of the standardised chromophore response axes.

The analysis considers two chromophore combinations:

- HbO₂ and oxCCO.
- HHb and oxCCO.

One-sample t-tests are used to assess whether relative power and relative cost values differ significantly from zero across infants at each channel. FDR correction is used to account for multiple comparisons. Scatterplots illustrate the chromophore relationships across channels and the axes used to derive relative power and relative cost.

The analysis can be performed separately for positive and negative response groups.

## Requirements and inputs

- MATLAB.
- The Signal Processing Toolbox 
- The Statistics and Machine Learning Toolbox.
- Original input detector-intensity files, timing files, serial-capture files, and wavelength reference files in the formats expected by the scripts.


## Notes on this code release

The scripts are provided to document and reproduce the original analysis workflow. Some filenames, variable names and comments reflect the original project and have been retained for consistency with the analysis.

The code should be run with the corresponding input data and MATLAB environment. Any modifications required to accommodate different datasets or software environments should be documented, as changes to processing parameters, event definitions or analysis procedures may affect the results.

## Citation and reuse

Please cite the associated Wellcome Open Research article and this repository's archived DOI when using the code.
