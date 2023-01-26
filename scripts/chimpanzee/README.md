# Chimpanzee BA44 and BA45 Atlas Pipeline
This folder contains the scripts used to create the chimpanzee BA44 and BA45 atlas in the JUNA space.

### Step 1: Preprocessing the Individual Volumes (`./1.prepare_for_freesurfer/`) 
All individual volumes (not included in this release) where preprocessed following the same pipeline.

The general pipeline is present in [./1.prepare_for_freesurfer/general/prepare_for_freesurfer.sh](./1.prepare_for_freesurfer/general/prepare_for_freesurfer.sh). 

This script takes as input the subject name (e.g. `C0408`), and a set of parameters that set the exact values needed for a specific individual.

The pipeline then proceeds to:
1. Transform the original file to `.nii`
2. Flip the image if necessary
3. Remove the background
4. Change the vox. resolution to `0.7mm` isometric
5. Invert the colors
6. Apply a minimum blur to the image

A particular instantiation can be found in the file `individual.sh`.

### Step 2: Processing the Individual Volumes with Freesurfer (`./2.process_with_freesurfer/`) 
Each chimpanzee volume passed through a similar pipeline to reconstruct their individual surfaces. An example can be found in [./2.process_with_freesurfer/individual.s](./2.process_with_freesurfer/individual.sh). 

This script takes the preprocessed subject's volume name, and then proceeds to run batches of freesurfer-steps, until the final reconstruction is obtained. 

### Step 3: Transform files to GIFTI (`./3.transform_surfaces_and_ROIs`)
This step transforms the computed surfaces into GIFTI files, and projects the volumetric cytoarchitectural ROIs into the individual surfaces.

### Step 4: Register to the JUNA chimpanzee template and Compute the Atlas (`./4.create_atlas`)
In the last step, the individual brains are registered to the JUNA template, where their reconstructions are averaged to derive the probabilistic atlas.
