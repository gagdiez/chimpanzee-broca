#!/usr/bin/env python
'''Remove border high values'''
import nibabel
import numpy as np
import sys
from skimage import filters, morphology

if len(sys.argv) < 5:
    print("Usage ./remove_high_border_values.py in out border_vox laplacian_value")
    exit()

def erode_n_times(mask, times=1):
    eroded = morphology.binary_erosion(mask)
    for _ in range(1, times):
        eroded = morphology.binary_erosion(eroded)
    return eroded

print("Removing outter border")
nifti = nibabel.load(sys.argv[1])

data = nifti.get_fdata()

mask = data > 0
times = int(sys.argv[3])
border = np.bitwise_xor(mask, erode_n_times(mask, times))
border = border.astype(bool)

filtered = filters.laplace(data)
high_contrast = np.abs(filtered) > int(sys.argv[4])
data[border * high_contrast] = 0

# nif_image = nibabel.Nifti1Image(filtered, nifti.affine, nifti.header)
# nibabel.save(nif_image, sys.argv[2]+"laplace.nii.gz")

# nif_image = nibabel.Nifti1Image(border, nifti.affine, nifti.header)
# nibabel.save(nif_image, sys.argv[2]+"border.nii.gz")

nif_image = nibabel.Nifti1Image(data, nifti.affine, nifti.header)
nibabel.save(nif_image, sys.argv[2])
