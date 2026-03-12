import os
import sys
from collections import defaultdict

indir = 'Bowtie2_Mappings_EPIC_SMGC_and_EMAGs/'
metagenome_info = 'metagenome_info.txt'

data = {}
for f in os.listdir(indir):
    mg = f.split('.')[0].replace('_', '-')
    with open(indir + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data[mg] = line.split('% overall alignment rate')[0]

mgs = set([])
with open(metagenome_info) as osf:
    for line in osf:
        line = line.strip()
        ls = line.split('\t')
        mgs.add(tuple(ls))

above = 0
total = 0
for mg in mgs:
    rate = float(data[mg[0]])
    if rate >= 75.0:
        above += 1
    total += 1

print(above/total)
print(total)
