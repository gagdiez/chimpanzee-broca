#!/usr/bin/env python

import citrix
import numpy as np

chimps = ["anna", "atlanta", "dobbs", "hoboh", "jorg", "lucy", "mortimer", "storer"]
volumes = {'lh': [], 'rh': []}

for name, regions in zip(["BA44", "BA45"], [[2,4], [3,5]]):
    print(name)
    for r, h in zip(regions, ['lh', 'rh']):
        for c in chimps:
            data = citrix.load(f'./results/{c}.{h}.{name}.nii').get_fdata() == r
            volumes[h].append(data.sum())

        print(h, np.mean(volumes[h]), np.std(volumes[h]))
