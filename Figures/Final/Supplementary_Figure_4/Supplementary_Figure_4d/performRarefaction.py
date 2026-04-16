import os
import sys
from collections import defaultdict
from operator import itemgetter

input_file = 'Input.txt'
bigscape_mix_file = 'BiG-SCAPE_Results/network_files/2026-03-03_10-12-52_hybrids_glocal/mix/mix_clustering_c0.30.tsv'

mg_gcfs = defaultdict(set)
with open(bigscape_mix_file) as obmf:
    for line in obmf:
        line = line.strip()
        ls = line.split('\t')
        mg = ls[0].split('_')[0].replace('_', '-')
        mg_gcfs[mg].add(ls[1])

bs_mgs = defaultdict(list)
with open(input_file) as oif:
    for line in oif:
        line = line.strip()
        ls = line.split('\t')
        bs_mgs[ls[1]].append([ls[0].replace('_', '-'), float(ls[2])])

print('BodySite\tCumulativeDepth\tGCFsDiscovered')
for bs in bs_mgs:
    cum_depth = 0
    cum_gcfs = set([])
    print(bs + '\t0.0\t0')
    for mg, mg_depth in sorted(bs_mgs[bs], key=itemgetter(1), reverse=True):
        cum_depth += mg_depth
        cum_gcfs = cum_gcfs.union(mg_gcfs[mg])
        print(bs + '\t' + str(cum_depth) + '\t' + str(len(cum_gcfs)))
