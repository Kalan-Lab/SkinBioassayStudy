import os
import sys
from collections import defaultdict
from operator import itemgetter

input_file = 'Input.txt'

bs_mgs = defaultdict(list)
mg_gcfs = {}
with open(input_file) as oif:
    for line in oif:
        line = line.strip()
        ls = line.split('\t')
        bs_mgs[ls[1]].append([ls[0], float(ls[2])])
        gcfs = set(ls[-1].split(', '))
        mg_gcfs[ls[0]] = gcfs

print('BodySite\tCumulativeDepth\tGCFsDiscovered')
for bs in bs_mgs:
    cum_depth = 0
    cum_gcfs = set([])
    print(bs + '\t0.0\t0')
    for mg, mg_depth in sorted(bs_mgs[bs], key=itemgetter(1), reverse=True):#False):
        cum_depth += mg_depth
        cum_gcfs = cum_gcfs.union(mg_gcfs[mg])
        print(bs + '\t' + str(cum_depth) + '\t' + str(len(cum_gcfs)))
