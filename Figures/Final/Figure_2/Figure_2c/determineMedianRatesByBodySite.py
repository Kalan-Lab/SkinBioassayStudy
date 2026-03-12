import os
import sys
from collections import defaultdict
import statistics

indir = 'Bowtie2_Mappings_EPIC_SMGC_and_EMAGs/'
metagenome_info = 'metagenome_info.txt'

data = {}
for f in os.listdir(indir):
    mg = f.split('.')[0].replace('_', '-')
    with open(indir + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data[mg] = float(line.split('% overall alignment rate')[0])

site_type_rates = defaultdict(list)
with open(metagenome_info) as osf:
    for line in osf:
        line = line.strip()
        ls = line.split('\t')
        site_type = ls[-1]
        rate = data[ls[0]]
        site_type_rates[site_type].append(rate)

for st in site_type_rates:
    str_values = site_type_rates[st]
    str_median = statistics.median(str_values)
    print(st + '\t' + str(str_median))
