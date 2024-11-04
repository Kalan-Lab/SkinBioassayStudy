import os
import sys

ffile = 'Fungal_Bioactivity_Scores.txt'
gnfile = 'GramNeg_Bioactivity_Scores.txt'
gpfile = 'GramPos_Bioactivity_Scores.txt'

tax_file = 'taxa_info.txt'
gtp_file = 'Genus_to_Phylum.txt'

gtop = {}
with open(gtp_file) as ogf:
    for line in ogf:
        line = line.strip('\n')
        ls = line.split('\t')
        gtop[ls[0]] = ls[1]

genus = {}
phylum = {}
with open(tax_file) as otf:
    for i, line in enumerate(otf):
        if i == 0: continue
        line = line.strip('\n')
        ls = line.split('\t')
        if not ls[-1] in gtop: continue
        genus[ls[0]] = ls[-1]
        phylum[ls[0]] = gtop[ls[-1]]

print('Target\tIsolate\tSummmaryScore\tNumberTested\tIsolateGenus\tIsolatePhylum')
for f in [ffile, gnfile, gpfile]:
    with open(f) as off:
        for line in off:
            line = line.strip()
            ls = line.split('\t')
            print(line + '\t' + genus[ls[1]] + '\t' + phylum[ls[1]])
