#!/usr/bin/env python
'''Invert intensities of an image'''
import nibabel
import sys
import numpy as np
from skimage import filters, morphology

if len(sys.argv) < 4:
    print("Usage: ./invert_intensities.py IN OUT THR")
    exit()

THR = int(sys.argv[3])

print(f"Inverting intensities above {THR}")

nifti = nibabel.load(sys.argv[1])

data = nifti.get_fdata()

mask = data > THR
masked = data[mask]
mx = data.max()

masked = (np.ones(masked.shape) - masked / mx)*mx + THR/mx
data /= mx
data[mask] = masked

nif_image = nibabel.Nifti1Image(data, nifti.affine, nifti.header)
nibabel.save(nif_image, sys.argv[2])
