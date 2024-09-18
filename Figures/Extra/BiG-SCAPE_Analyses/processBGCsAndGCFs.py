import os
import sys
from Bio import SeqIO
from collections import defaultdict

antismash_listing_file = 'All_BGC_Genbanks.txt'
bigscape_clustering_file = 'bigscape_mix_results/mix_clustering_c0.30.tsv' 
smgc_taxa_file = 'SMGC_Taxa_Info.txt'
lk_taxa_file = 'LK_Taxa_Info.txt'
derep_lk_file = 'Dereplication_Results_99.txt'

genus_info = defaultdict(lambda: 'NA')
species_info = defaultdict(lambda: 'NA')
with open(smgc_taxa_file) as ostf:
    for line in ostf:
        line = line.strip()
        ls = line.split('\t')
        if ls[1] != 'g__':
            genus_info[ls[0]] = ls[1][3:]
        if ls[2] != 's__':
            species_info[ls[0]] = ls[2][3:]

with open(lk_taxa_file) as oltf:
    for line in oltf:
        line = line.strip()
        lk, taxa = line.split('\t')
        if 'g__' in taxa:
            genus = taxa.split('g__')[1].split(';')[0]
            if genus != '': genus_info[lk] = genus
        if 's__' in taxa:
            species = taxa.split('s__')[1].split(';')[0]
            if species != '': species_info[lk] = species

bgc_to_sample = {}
bgc_to_size = {}
bgc_to_contig_edge = {}
bgc_to_products = {}
bgc_to_product_simple = {}
with open(antismash_listing_file) as oalf:
    for line in oalf:
        line = line.strip()
        ls = line.split('\t')
        bgc = ls[1].split('/')[-1].split('.gbk')[0]
        sample = ls[0]
        contig_edges = []
        products = []
        length = None
        with open(ls[1]) as obgc:
            for rec in SeqIO.parse(obgc, 'genbank'):
                for feature in rec.features:
                    if feature.type == 'protocluster':
                        contig_edge = feature.qualifiers.get('contig_edge')[0]
                        contig_edges.append(contig_edge)
                        product = "NA"
                        try:
                            product = feature.qualifiers.get('product')[0]
                        except:
                            pass
                        products.append(product)
                length = len(str(rec.seq))
        is_contig_edge = 'False'
        if 'True' in set(contig_edges):
            is_contig_edge = 'True'
        product_string = '; '.join(sorted(set(products)))
        product_simple = products[0]
        if len(set(products)) > 1:
            product_simple = 'hybrid'
            if len(set(products)) == 2:
                if 'NRPS' in products and 'NRPS-like' in products:
                    product_simple = 'NRPS'
        bgc_to_size[bgc] = length
        bgc_to_sample[bgc] = sample
        bgc_to_contig_edge[bgc] = is_contig_edge
        bgc_to_products[bgc] = product_string
        bgc_to_product_simple[bgc] = product_simple
        
bgc_gcfs = defaultdict(set)
with open(bigscape_clustering_file) as ocf:
    for i, line in enumerate(ocf):
        if i == 0: continue
        line = line.strip()
        bgc, gcf = line.split('\t')
        bgc_gcfs[bgc].add(gcf)

derep_lk_set = set([])
with open(derep_lk_file) as odlf:
    for line in odlf:
        line = line.strip()
        derep_lk_set.add(line)

for bgc in bgc_gcfs:
    gcfs = '; '.join([x for x in sorted(bgc_gcfs[bgc])])
    if not bgc in bgc_to_sample:
        print('\t'.join(['NA','MIBiG', 'NA', bgc, 'NA', 'NA', 'NA', 'NA', 'NA', gcfs, 'NA', 'NA']))
    elif bgc_to_sample[bgc].startswith('LK'):
        print('\t'.join([bgc_to_sample[bgc], 'LK', str(bgc_to_sample[bgc] in derep_lk_set), bgc, bgc_to_contig_edge[bgc], str(bgc_to_size[bgc]), bgc_to_product_simple[bgc], bgc_to_products[bgc], gcfs, genus_info[bgc_to_sample[bgc]], species_info[bgc_to_sample[bgc]]]))
    elif bgc_to_sample[bgc].startswith('SMGC'):
        print('\t'.join([bgc_to_sample[bgc], 'SMGC', 'NA', bgc, bgc_to_contig_edge[bgc], str(bgc_to_size[bgc]), bgc_to_product_simple[bgc], bgc_to_products[bgc], gcfs, genus_info[bgc_to_sample[bgc]], species_info[bgc_to_sample[bgc]]]))

