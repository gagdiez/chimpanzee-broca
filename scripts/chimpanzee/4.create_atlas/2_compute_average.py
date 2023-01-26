#!/usr/bin/env python

import citrix
import numpy as np
from glob import glob


hems = ['lh', 'rh']
size = [162150, 162260]
structure = [citrix.structures.CORTEX_LEFT, citrix.structures.CORTEX_RIGHT]
labels = [{44:2, 45:3}, {44:4, 45:5}]

# Broca
for h, s, struc, lab in zip(hems, size, structure, labels):
    avg = np.zeros(s)

    brocas = glob(f'./results/*/labels/{h}.*.broca.*')
    maps = {44: np.zeros_like(avg), 45: np.zeros_like(avg)}

    for r in brocas:
       maps[44] += citrix.load(r).function_data == lab[44]
       maps[45] += citrix.load(r).function_data == lab[45]

    maps[44] /= len(brocas)
    maps[45] /= len(brocas)

    m44 = citrix.build.gifti.function(maps[44], struc)
    m44.to_filename(f'./results/{h}.BA44.atlas.func.gii')

    m45 = citrix.build.gifti.function(maps[45], struc)
    m45.to_filename(f'./results/{h}.BA45.atlas.func.gii')