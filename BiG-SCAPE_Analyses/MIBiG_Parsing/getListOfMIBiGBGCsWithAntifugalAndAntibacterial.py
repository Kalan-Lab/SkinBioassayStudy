import os
import sys
from collections import defaultdict

gcfs = set([])
with open('LK_GCFs.txt') as olg:
    for line in olg:
        line = line.strip()
        gcfs.add(line)

mibig_json_dir = 'mibig_json_3.1/'

antifungal = set([])
antibacterial = set([])

for f in os.listdir(mibig_json_dir):
    bgc = f.split('.json')[0]
    with open(mibig_json_dir + f) as oj:
        for line in oj:
            line = line.strip()
            if '"activity": "antifungal"' in line:
                antifungal.add(bgc)
            elif '"activity": "antibacterial"' in line:
                antibacterial.add(bgc)

print
with open('BGC_Centric_View.txt') as obcv:
    for line in obcv:
        line = line.strip()
        ls = line.split('\t')
        if ls[9] in gcfs and 'BGC' in ls[3]:
            bgc = ls[3]
            af = 'False'
            ab = 'False'
            flag = False
            if bgc in antifungal:
                af = 'True'
                flag = True
            if bgc in antibacterial:
                ab = 'True'
                flag = True
            if flag:
                print(bgc + '\t' + ls[9] + '\t' + ab + '\t' + af)

