# ASL processing
Processing scripts for ASL data to extract cerebral blood flow (CBF) and cerebrovascular reactivity (CVR) maps.

Scripts were developed by Sara Dupont (sara.m.dupont@gmail.com), a research associate with UCSF working at ZSFG; as an employee of UCSF, her work is intellectual property of UCSF.

## Purpose
This group of scripts is written to process ASL data to compute cerebral blood flow (CBF) and cerebrovascular reactivity (CVR) as follow: 
Processing steps: 
1. Process ASL to get CBF: 
    - Motion correction: register each tag and control frame to the 1st control frame
    - Denoising of each frame
    - Intensity normalization of each individual frame based on the intensity of the 1st control frame
    - Average of control frames and tag frames (separately) to increase SNR
    - Difference Control-Tag to get perfusion weighted image 
    - Computation of CBF from the perfusion weighted image and proton density weighted image (also called M0, usually the 1st control frame is used) —> See Alsop et al., MRM, 2015
2. Process the breathing challenge data to get averaged End-Tidal CO2 (ETCO2) values
    - Smooth raw input signal
    - Get derivative of signal (i.e. gradient) 
    - Find peaks of derivative = areas of steepest slope in raw signal
    - Find end of plateau based on a constant lag of 0.6 sec between steepest slope and end of plateau 
    - Average all ETCO2 values within the time window
3. Get CVR from basal CBF, CBF during challenge and ETCO2 values (CVR = difference in CBF normalized by the difference in ETCO2) —> See Leoni et al., RRP, 2012
4. Get brain parcellation and extract values within ROIs (with FSL tools)
    - Segment brain on the T1 image
    - Register MNI template to T1 
    - Register T1 to CVR and CBF maps 
    - Concatenate both registrations to bring the MNI template and atlas (HarvardOxford) in the CBF and CVR space
    - Extract values within each ROI 

## Additional features
 - If the vasoreactivity challenge isn't a CO2 breathing challenge, option to compute the CVR as a percentage difference (not normalized by the change of ETCO2). 
 - If the total brain CBF value is available (from a phase contrast scan for example), option to correct the labelling efficiency when computing the CBF map from ASL data.
 - If the sequence used for teh ASL outputs a CBF map already processed, option to input directly the CBF map for subsequent CVR computation and ROI values extraction. 

## Installation

### Install prerequisites

1. [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
1. [`dcm2niix`](https://github.com/rordenlab/dcm2niix#Install)
1. `python2.7`: For example, if using the Anaconda distribution, you can set up and activate a new virtual environment like:

    ```
    conda create --name asl python=2.7
    conda activate asl
    ``` 

### Install `ASL_processing` package

Copy the repository URL `repo_url` from github. E.g.

![image](https://user-images.githubusercontent.com/473295/81104935-154a0f80-8ec8-11ea-953c-677f0e5ecacc.png)

Then install the `ASL_processing` package like:

```
pip install git+<repo_url>
```

### Docker

Instead of installing within your local environment, you can run the processing within a docker container based off the standard [`johncolby/asl`](https://hub.docker.com/r/johncolby/asl) image.

A small wrapper script is included at: [`process_data_docker`](bin/process_data_docker)

This wrapper is installed along with the python package. However, it also can be downloaded separately like: 
```
curl -O https://raw.githubusercontent.com/johncolby/ASL_processing/master/bin/process_data_docker
chmod +x process_data_docker
```

## Usage

```
process_data --config my_config_file.json
```

or 

```
process_data_docker --config my_config_file.json
```

The streamlined processing is scripted in `process_data` and all the parameters need to be set in a JSON config file using the format of input as shown in `config_default.json`.

To call this script, copy and past the file `config_default.json` to your working directory, and **modify the input parameters to point to your data**. You can also **choose which processing to apply** and change the **processing parameters** and **acquisition parameters**. 

At the end of the script, a new version of the config file is saved in the output folder, to have access to the file names of the images computed during the processing as well as other data (for ex. ETCO2) and easily store that information.
