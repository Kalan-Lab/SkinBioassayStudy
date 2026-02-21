import os
import sys
from collections import defaultdict
from Bio import SeqIO

bigscape_dir = '../BiG-SCAPE_Analysis/Results/network_files/2023-03-03_20-50-01_glocal/'

bgc_to_gcf = defaultdict(lambda: 'NA')
for cd in os.listdir(bigscape_dir):
    clust_file = bigscape_dir + cd + '/' + cd + '_clustering_c0.30.tsv'
    if not os.path.isfile(clust_file): continue 
    with open(clust_file) as ocf:
        for line in ocf:
            line = line.strip()
            if line.startswith('#'): continue
            ls = line.split('\t')
            bgc_to_gcf[ls[0]] = ls[1]

bigmap_family_file = sys.argv[1]

with open(bigmap_family_file) as otbf:
    for rec in SeqIO.parse(otbf, 'fasta'):
        rep = rec.id.split('|')[1]
        print(rec.id + '\t' + bgc_to_gcf[rep] + '\t' + str(len(rec.seq)))
