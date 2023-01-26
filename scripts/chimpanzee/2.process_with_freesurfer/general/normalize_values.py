#!/usr/bin/env python
import nibabel
import sys

if(len(sys.argv) < 3):
    print("Usage: ./normalize_values.py in out max")

orig = nibabel.load(sys.argv[1])
data = orig.get_fdata()
norm = (data / data.max()) * int(sys.argv[3])
img = nibabel.MGHImage(norm, orig.affine, orig.header)
img.to_filename(sys.argv[2])
