#!/usr/bin/env python
import nibabel
import sys

from skimage import filters
from scipy.ndimage import morphology

if len(sys.argv) < 4:
    print("Usage: ./gaussian_masking IN:str OUT:str THR:int [UP_THR:int]")
    exit()

threshold = int(sys.argv[3])

if len(sys.argv) == 5:
    up_threshold = int(sys.argv[4])
else:
    up_threshold = None

print("Smoothing and separating from background using threshold:",
      f"{threshold} {up_threshold}")

nifti = nibabel.load(sys.argv[1])
data = nifti.get_fdata()

gaussian = filters.gaussian(data)

mask = (gaussian > threshold)

if up_threshold:
    mask = mask*(data < up_threshold)

mask_filled = morphology.binary_fill_holes(mask)

#import citrix
#citrix.save('gaussian.nii', gaussian, nifti.header, nifti.affine, 1)

data[~mask_filled] = 0

nif_image = nibabel.Nifti1Image(data, nifti.affine, nifti.header)
nibabel.save(nif_image, sys.argv[2])
