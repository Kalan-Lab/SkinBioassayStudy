import os
import sys
from collections import defaultdict

full_file = sys.argv[1]
core_file = sys.argv[2]
unfiltered_core_file = sys.argv[3]
bgc_annot_file = sys.argv[4]

bgc_to_annot = {}
with open(bgc_annot_file) as obaf:
    for line in obaf:
        line = line.strip()
        ls = line.split('\t')
        bgc_to_annot[ls[3]] = ls[6]

full_set = set([])
with open(full_file) as off:
    for line in off:
        line = line.strip()
        ls = line.split('\t')
        full_set.add(tuple([ls[0], ls[1]]))

gcf_counts = defaultdict(int)
core_keys = set([])
data = []
with open(core_file) as ocf:
    for i, line in enumerate(ocf):
        line = line.strip()
        if i == 0:
            #print(line)
            continue
        ls = line.split('\t')
        core_key = tuple([ls[0], ls[1]])
        if core_key in full_set:
            core_keys.add(core_key)
            gcf = ls[1]
            gcf_counts[gcf] += 1

print('sample\tbgc\tbgc_class\trpkm_norm\tcoverage\tsample_subject\tsample_bodysite')
with open(unfiltered_core_file) as oucf:
    for i, line in enumerate(oucf):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        if gcf_counts[ls[1]] < 5: continue
        core_key = tuple([ls[0], ls[1]])
        printlist = [ls[0], ls[1].split('|')[1], bgc_to_annot[ls[1].split('|')[1]]]
        if core_key in core_keys:
            printlist += [ls[3], ls[4]]
        else:
            printlist += ['NA', 'NA']
        printlist += ls[5:]
        print('\t'.join(printlist))
