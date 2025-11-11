import os
import sys
from collections import defaultdict
import statistics

met_abd_file = 'Genus_Abundance_and_Prevalence.txt'
bgc_file = 'BGC_Centric_View.txt'
afs_file = 'antifungal_scores.txt'

bgcome_sizes = defaultdict(int)
genus_isos = defaultdict(set)
iso_to_genus = {}
with open(bgc_file) as obf:
    for i, line in enumerate(obf):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        if ls[1] != 'LK': continue
        bgc_len = int(ls[5])
        iso_to_genus[ls[0]] = ls[-2]
        bgcome_sizes[ls[0]] += bgc_len
        genus_isos[ls[-2]].add(ls[0])

genus_abds = {}
genus_prev = {}
with open(met_abd_file) as omaf:
    for i, line in enumerate(omaf):
        if i == 0: continue
        line = line.strip('\n')
        ls = line.split('\t')
        genus_abds[ls[1]] = float(ls[2])
        genus_prev[ls[1]] = float(ls[3])


main_taxa = set(['Corynebacterium', 'Staphylococcus', 'Micrococcus', 'Kocuria', 'Cutibacterium', 'Rothia'])
with open(afs_file) as oaf:
    for i, line in enumerate(oaf):
        line = line.strip()
        if i == 0:
            print(line + '\tavg_rel_abd\tprevalence\tavg_bgcome_size\tcoloring\tlabel')    
        else:
            ls = line.split('\t')
            g = ls[0]
            if not g in genus_abds: continue
            if not g in genus_isos: continue
            ara = genus_abds[g]
            abos = statistics.mean([bgcome_sizes[x] for x in genus_isos[g]])
            arp = genus_prev[g]
            label = ''
            if g in main_taxa:
                label = g
            if abos >= 300000:
                label = g
            if float(ls[1]) >= 1.0:
                label = g

            coloring = 'other'
            if arp >= 67 and ara >= 1.0:
                coloring = 'prev_and_abd'
            elif arp >= 134:
                coloring = 'prev'
            elif ara >= 1.0:
                coloring = 'abd'

            print(line + '\t' + str(ara) + '\t' + str(arp) + '\t' + str(abos) + '\t' + coloring + '\t' + label)
