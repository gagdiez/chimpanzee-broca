#!/usr/bin/env python
'''Leaves only biggest component'''
import nibabel
import numpy as np
import sys

from skimage import measure

nifti = nibabel.load(sys.argv[1])
data = nifti.get_fdata()

labels = measure.label(data > 0)

largest_component = labels == np.argmax(np.bincount(labels.flat)[1:])+1

data[~largest_component] = 0

nif_image = nibabel.Nifti1Image(data, nifti.affine, nifti.header)
nibabel.save(nif_image, sys.argv[2])
