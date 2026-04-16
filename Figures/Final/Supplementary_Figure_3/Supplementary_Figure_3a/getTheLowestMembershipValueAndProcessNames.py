import os
import sys
from collections import defaultdict

raw_extraction_file = 'Extracted_Info_BGCs_to_BiGFAM.txt'

print('group\tsample\tbgc\tgcf\tdist')
with open(raw_extraction_file) as oref:
    for line in oref:
        line = line.strip()
        ls = line.split('\t')
        sample = ls[1].split('/')[-1]
        bgc = ls[2]
        gcf = ls[3]
        dist = ls[4]
        rank = ls[5]
        if rank == '0':
            group = 'SMGC'
            if sample.startswith('LK'): group = 'EPIC'
            print(group + '\t' + sample + '\t' + bgc + '\t' + gcf + '\t' + dist)
