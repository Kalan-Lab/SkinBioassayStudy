import os
import sys
from collections import defaultdict
from operator import itemgetter
import random
import math

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


bin_map = {'0': '0-1e8', 
           '1': '1e8-2e8', 
           '2': '2e8-3e8', 
           '3': '3e8-4e8', 
           '4': '4e8-5e8', 
           '5': '5e8-6e8', 
           '6': '6e8-7e8', 
           '7': '7e8-8e8',
           '8': '8e8-9e8',
           '9': '9e8-1e9'}

print('BodySite\tPermutation\tCumulativeDepth\tGCFsDiscovered')
for bs in bs_mgs:
    for i in range(0, 100):
        cum_depth = 0
        cum_gcfs = set([])
        curr_bs_mgs = bs_mgs[bs]
        random.shuffle(curr_bs_mgs)
        for mg, mg_depth in curr_bs_mgs: #sorted(bs_mgs[bs], key=itemgetter(1), reverse=True): #False):
            cum_depth += mg_depth
            cum_gcfs = cum_gcfs.union(mg_gcfs[mg])
            cum_depth_bin = bin_map[str(math.floor(cum_depth/100000000.0))]
            print(bs + '\t' + str(i+1) + '\t' + str(cum_depth_bin) + '\t' + str(len(cum_gcfs)))
