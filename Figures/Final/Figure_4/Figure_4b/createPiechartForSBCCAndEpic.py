import os
import sys
from collections import defaultdict
from ete3 import Tree

tab_file = 'SahebKashaf_2022_TableS4.txt'

sbcc = set([])
with open(tab_file) as otf:
    for i, line in enumerate(otf):
        if i < 2: continue
        line = line.strip()
        ls = line.split('\t')
        if ls[17].startswith('SBCC_'):
            sbcc.add(ls[0])

print('DATASET_PIECHART')
print('SEPARATOR TAB')
print('DATASET_LABEL\tDataset')
print('COLOR\t#000000')
print('FIELD_LABELS\t' + '\t'.join(['SBCC', 'EPIC']))
print('FIELD_COLORS\t' + '\t'.join(['"#d6ae3e"', '"#991e1a"']))
print('DATA')

t = Tree('GToTree_Results/GToTree_Results.tre')
for n in t.traverse('postorder'):
    if n.is_leaf():
        if n.name in sbcc:
            print(n.name + '\t1\t1\t1\t0')
        elif n.name.startswith('LK'):
            print(n.name + '\t1\t1\t0\t1')
