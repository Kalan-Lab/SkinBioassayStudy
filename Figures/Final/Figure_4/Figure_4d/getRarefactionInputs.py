import os
import sys
from collections import defaultdict

full_filt_file = sys.argv[1]
core_filt_file = sys.argv[2]
bigscape_file = sys.argv[3]
seq_depth_file = sys.argv[4]
gcf_annot_file = sys.argv[5]

gcf_annot = {}
with open(gcf_annot_file) as ogaf:
    for line in ogaf:
        line = line.strip()
        ls = line.split('\t')
        gcf_annot[ls[0]] = ls[1]

sample_depth = defaultdict(float)
with open(seq_depth_file) as osdf:
    for i, line in enumerate(osdf):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        sample_depth[ls[0]] += float(ls[-1])

rep_to_gcf = defaultdict(set)
with open(bigscape_file) as obf:
    for line in obf:
        line = line.strip()
        ls = line.split('\t')
        rep_to_gcf[ls[0]] = ls[1]

full_set = set([])
with open(full_filt_file) as off:
    for line in off:
        line = line.strip()
        ls = line.split('\t')
        full_set.add(tuple([ls[0], ls[1]]))

sample_gcfs = defaultdict(set)
sample_to_bs = {}
with open(core_filt_file) as ocf:
    for i, line in enumerate(ocf):
        line = line.strip()
        if i == 0:
            continue
        ls = line.split('\t')
        core_key = tuple([ls[0], ls[1]])
        if core_key in full_set:
            rep = ls[1].split('|')[1]
            gcf = rep_to_gcf[rep]
            bs = ls[-1]
            sample = ls[0]
            sample_to_bs[sample] = bs
            sample_gcfs[sample].add(gcf + '|' + gcf_annot[gcf])
            
for sample in sample_gcfs:
    print(sample + '\t' + sample_to_bs[sample] + '\t' + str(sample_depth[sample]) + '\t' + ', '.join(sample_gcfs[sample]))
