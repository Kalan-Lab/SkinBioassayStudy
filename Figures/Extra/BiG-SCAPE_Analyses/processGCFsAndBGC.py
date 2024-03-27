import os
import sys
from Bio import SeqIO
from collections import defaultdict
from operator import itemgetter
import statistics

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
        
gcf_bgcs = defaultdict(set)
with open(bigscape_clustering_file) as ocf:
    for i, line in enumerate(ocf):
        if i == 0: continue
        line = line.strip()
        bgc, gcf = line.split('\t')
        gcf_bgcs[gcf].add(bgc)

derep_lk_set = set([])
with open(derep_lk_file) as odlf:
    for line in odlf:
        line = line.strip()
        derep_lk_set.add(line)

for gcf in gcf_bgcs:
    num_bgcs = len(gcf_bgcs[gcf])
    has_mibig = 0
    has_lk = 0
    has_smgc = 0
    annots = defaultdict(int)
    taxa = defaultdict(int)
    bgc_lengths = []
    for bgc in gcf_bgcs[gcf]:
        if 'SMGC' in bgc:
            has_smgc += 1
        elif 'LK' in bgc:
            has_lk += 1
        elif 'BGC' in bgc:
            has_mibig += 1
        if bgc in bgc_to_product_simple:
            annots[bgc_to_product_simple[bgc]] += 1
        if bgc in bgc_to_sample:
            samp = bgc_to_sample[bgc]
            if samp in genus_info:
                taxa[genus_info[samp]] += 1
        if bgc in bgc_to_size:
            bgc_lengths.append(bgc_to_size[bgc])

    if not has_lk and not has_smgc: continue
    annot_string = []
    major_annot = 'hybrid'
    tot_count = sum(annots.values())
    for i, an in enumerate(sorted(annots.items(), key=itemgetter(1), reverse=True)):
        annot_string.append(an[0] + '=' + str(an[1]))
        if an[0] == 'hybrid' and an[1] >= 0.25:
            major_annot = 'hybrid'
        elif i == 0 and an[1]/float(tot_count) > 0.5:
            major_annot = an[0]

    taxa_string = []
    major_taxa = 'NA'
    tot_count = sum(taxa.values())
    for i, tx in enumerate(sorted(taxa.items(), key=itemgetter(1), reverse=True)):
        taxa_string.append(tx[0] + '=' + str(tx[1]))
        if i == 0 and tx[1]/float(tot_count) > 0.5:
            major_taxa = tx[0]

    print('\t'.join([gcf, major_annot, major_taxa, ', '.join(annot_string), ', '.join(taxa_string), str(statistics.median(bgc_lengths)), str(num_bgcs), str(has_lk), str(has_smgc), str(has_mibig)]))
