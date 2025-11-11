import os
import sys
from collections import defaultdict

prev_file = '../Top_Genera_per_Sample.txt'
brack_dir = 'Bracken_Results/'

info = {}
with open(prev_file) as opf:
    for line in opf:
        line = line.strip()
        ls = line.split('\t')
        info[ls[0]] = [ls[1], ls[2]]

print('Sample\tSampleSubject\tSampleBodySite\tTaxa\tEstimated_Reads')
for f in os.listdir(brack_dir):
    tot_reads = 0
    genus_reads = defaultdict(int)
    with open(brack_dir + f) as obf:
        for i, line in enumerate(obf):
            if i == 0: continue
            line = line.strip()
            ls = line.split('\t')
            read_count =  int(ls[-2])
            tot_reads += read_count
            genus = ls[0].split()[0]
            genus_reads[genus] += read_count
    
    cuti = genus_reads['Cutibacterium']
    coryne = genus_reads['Corynebacterium']
    micro = genus_reads['Micrococcus']
    staph = genus_reads['Staphylococcus']
    other = tot_reads - cuti - coryne - micro - staph

    sample = f.split('.bracken')[0][2:]
    if not sample in info: continue

    print('\t'.join([sample, info[sample][0], info[sample][1], 'Cutibacterium', str(cuti)]))
    print('\t'.join([sample, info[sample][0], info[sample][1], 'Corynebacterium', str(coryne)]))
    print('\t'.join([sample, info[sample][0], info[sample][1], 'Micrococcus', str(micro)]))
    print('\t'.join([sample, info[sample][0], info[sample][1], 'Staphylococcus', str(staph)]))
    print('\t'.join([sample, info[sample][0], info[sample][1], 'Other', str(other)]))
