# Comparing the Chimpanzee Broca with its Human Homolog and Functional Subdivisions

This folder contains the files used to compare the Chimpanzee BA44 and BA45 projected to the MNI human template (ICBM152 9c Asymmetric), with an atlas of the human BA44 and BA45 [1], and functional studies [2][3].

To visualize and manipulate these files you will need the [Connectome Workbench](https://www.humanconnectome.org/software/connectome-workbench), and software compatible with [ipython notebooks](https://jupyter.org).

When visualizing th results, please notice that you need to load a surface file (`.surf.gii`) in the [Connectome Workbench](https://www.humanconnectome.org/software/connectome-workbench) before loading any atlas file (`.func.gii`).


---
### `./MNI-surface-reconstruction (folder)`
3D reconstructions of the MNI human brain template (ICBM152 9c Asymmetric). A variety of surfaces are available:
- White surface: 3D reconstruction of the white-matter surface
- Pial surface: 3D reconstruction of the gray-matter surface
- Inflated: Inflated version of the gray matter, for better visualization purposes
- Sphere: Spherical mapping of the cortical surface, useful for cortical registrations. 

### `./broca-ROIs (folder)`
Probabilistic atlas of BA44 and BA45 in the MNI space for both humans and chimpanzees. The file names follow a pattern `{species}.{hemisphere}.BA{R}.func.gii`, where `species` is either `human` or `chimp`, `hemisphere` is either `lh` (left) or `rh` (right), and `R` is `44` or `45`.

For example, the file `human.lh.BA44.func.gii` can be loaded over the MNI reconstruction of the left hemisphere, and will show the human probabilistic atlas for BA44.

### `./functional-ROIs (folder)`
Contains the regions reported by Clos et al. [3] and Papitto et al. [4] projected to the cortical surface of the MNI template.

### `Areas Overlap.ipynb`
Ipython notebook used to compute the overlap between the chimpanzee BA44 projected to MNI the regions present in `functional-ROIs`.


[1] Amunts K, Schleicher A, Bürgel U, Mohlberg H, Uylings HB, Zilles K. Broca’s region revisited: cytoarchitecture and intersubject variability. J Comp Neurol. 1999;412: 319–341.
[2] Clos M, Amunts K, Laird AR, Fox PT, Eickhoff SB. Tackling the multifunctional nature of Broca’s region meta-analytically: co-activation-based parcellation of area 44. Neuroimage. 2013;83: 174–188.
[3] Papitto G, Friederici AD, Zaccarella E. The topographical organization of motor processing: An ALE meta-analysis on six action domains and the relevance of Broca’s region. Neuroimage. 2020;206: 116321.