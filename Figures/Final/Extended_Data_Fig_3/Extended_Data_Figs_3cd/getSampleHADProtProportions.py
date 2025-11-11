import os
import sys
from collections import defaultdict

all_prots = defaultdict(set)
with open('EPIC_All_Proteins.faa') as oaspf:
    for line in oaspf:
        line = line.strip()
        if line.startswith('>'):
            p = line[1:]
            s = p.split('|')[0]
            all_prots[s].add(p)

host_assoc_doms = set([])
with open('Pfam_HostAssoc_In_3orMoreGenera.txt') as opf:
    for line in opf:
        host_assoc_doms.add(line.strip().split('.')[0])


sample_prots = defaultdict(set)
with open('EPIC_Pfam_Annotations.txt') as opf:
    for line in opf:
        line = line.strip()
        ls = line.split('\t')
        s = ls[2].split('|')[0]
        if ls[0].split('.')[0] in host_assoc_doms:
            sample_prots[s].add(ls[2])

for s in sample_prots:
    print(s + '\t' + str(len(sample_prots[s])/len(all_prots[s])))
