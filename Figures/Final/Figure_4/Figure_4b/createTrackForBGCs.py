import os
import sys
from collections import defaultdict

bgc_info_file = 'BGC_Centric_View.txt'
bgc_color_file = 'Color_Mapping.txt'

bgc_colors = {}
with open(bgc_color_file) as obcf:
    for i, line in enumerate(obcf):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        bgc_colors[ls[0]] = ls[1]

sample_class_count = defaultdict(lambda: defaultdict(int))
samples = set([])
with open(bgc_info_file) as obcf:
    for line in obcf:
        line = line.strip()
        ls = line.split('\t')
        if ls[0].startswith('SMGC') or ls[0].startswith('LK'):
            samples.add(ls[0])
            sample_class_count[ls[0]][ls[6]] += 1

print('DATASET_MULTIBAR')
print('SEPARATOR TAB')
print('COLOR\t#000000')
print('DATASET_LABEL\tGCFs')
print('FIELDS\t' + '\t'.join([bgc for bgc in sorted(bgc_colors)]))
print('FIELD_COLORS\t' + '\t'.join([bgc_colors[bgc] for bgc in sorted(bgc_colors)]))
print('DATA')
for s in samples:
    printlist = [s]
    for gcf in sorted(bgc_colors):
        printlist.append(str(sample_class_count[s][gcf]))
    print('\t'.join(printlist))
