import os
import sys
from collections import defaultdict
from Bio import SeqIO
from scipy import stats

host_assoc_doms = set([])
with open('Pfam_HostAssoc_In_3orMoreGenera.txt') as opf:
    for line in opf:
        host_assoc_doms.add(line.strip().split('.')[0])

bgc_prots = set([])
with open('BGC_Proteins_Listing.txt') as oblf:
    for line in oblf:
        line = line.strip()
        bgc_prots.add(line)

ha_prots = set([])
with open('EPIC_Pfam_Annotations.txt') as opf:
    for line in opf:
        line = line.strip()
        ls = line.split('\t')
        if ls[0].split('.')[0] in host_assoc_doms:
            ha_prots.add(ls[2])

bgc_had = 0
other_had = 0
bgc_lack = 0
other_lack = 0 
with open('EPIC_All_Proteins.faa') as opf:
    for rec in SeqIO.parse(opf, 'fasta'):
        pid = rec.id
        if pid in ha_prots:
            if pid in bgc_prots:
                bgc_had += 1
            else:
                other_had += 1
        else:
            if pid in bgc_prots:
                bgc_lack += 1
            else:
                other_lack += 1

print('BGC - HAD:\t' + str(bgc_had))
print('BGC - wo HAD:\t' + str(bgc_lack))
print('BGC HAD Frequency:\t' + str(bgc_had/(bgc_had+bgc_lack)))
print('Other - HAD:\t' + str(other_had))
print('Other - wo HAD:\t' + str(other_lack))
print('Other HAD Frequency:\t' + str(other_had/(other_had+other_lack)))
print(stats.fisher_exact([[bgc_had, bgc_lack], [other_had, other_lack]], alternative='greater'))
