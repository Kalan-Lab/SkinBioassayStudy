import os
import sys
from collections import defaultdict


lk_to_site_file = 'taxa_info.txt'
bgc_file = 'GCF_Centric_View.txt'
bs_cluster_file = 'mix_clustering_c0.30.tsv'

lk_to_site = {}
site_to_type = {'Alar crease': 'Sebaceous', 'Nares': 'Moist', 'Back': 'Sebaceous', 'Umbilicus': 'Moist', 'Antecubital fossa': 'Rarely Moist', 'Occiput': 'Sebaceous', 'Toe web space': 'Moist', 'Volar forearm': 'Moist'}

with open(lk_to_site_file) as olsf:
    for i, line in enumerate(olsf):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        lk = ls[0]
        site = ls[4]
        lk_to_site[lk] = site

gcf_lks = defaultdict(set)
with open(bs_cluster_file) as obcf:
    for line in obcf:
        line = line.strip()
        ls = line.split('\t')
        if line.startswith('LK'):
            lk = ls[0].split('.')[0].split('_')[0]
            gcf = ls[1]
            gcf_lks[gcf].add(lk)

site_cat_counts = defaultdict(lambda: defaultdict(set))
with open(bgc_file) as obf:
    for line in obf:
        line = line.strip()
        ls = line.split('\t')
        cat = ls[1]
        gcf = ls[0]
        for lk in gcf_lks[gcf]:
            site = lk_to_site[lk] 
            site_cat_counts[site][cat].add(gcf)

for site in site_cat_counts:
    tot_gcfs = set([])
    for cat in site_cat_counts[site]:
        tot_gcfs = tot_gcfs.union(site_cat_counts[site][cat])

    for cat in site_cat_counts[site]:
        count = len(site_cat_counts[site][cat])
        freq = count/float(len(tot_gcfs))
        print('\t'.join([str(x) for x in [cat, site, count, site_to_type[site], freq]]))
