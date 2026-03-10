import os
import sys
from collections import defaultdict

fastani_smgc_results = 'fastANI_EPIC_MAGs_to_SMGC.txt'
fastani_epic_results = 'fastANI_EPIC_MAGs_to_EPIC_Isolates.txt'
checkm2_results = 'CheckM2_Results_quality_report.tsv'
gtdb_results = 'gtdbtk.bac120.summary.tsv'
abyss_results = 'AbyssFac_Stats.txt'
trnascan_dir = 'tRNAScan-SE_Results/'
infernal_dir = 'Infernal_Results/'

mg_trnas = defaultdict(set)
for f in os.listdir(trnascan_dir):
    mg = f.split('.txt')[0]
    with open(trnascan_dir + f) as otf:
        for i, line in enumerate(otf):
            if i < 3: continue
            line = line.strip()
            ls = line.split("\t")
            mg_trnas[mg].add(ls[4])

mg_rrnas = defaultdict(set)
for f in os.listdir(infernal_dir):
    mg = f.split('.txt')[0]
    with open(infernal_dir + f) as oif:
        for line in oif:
            if line.startswith('#'): continue
            line = line.strip()
            ls = line.split()
            mg_rrnas[mg].add(ls[3])

abyss_stats = {}
with open(abyss_results) as oar:
    for i, line in enumerate(oar):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        mg = ls[-1].split('/')[-1].split('.fasta')[0] 
        gs = ls[-2]
        n50 = ls[5]
        abyss_stats[mg] = [gs, n50]

epic_best_hits = defaultdict(lambda: ["NA", 0.0, 0.0])
with open(fastani_epic_results) as ofer:
    for i, line in enumerate(ofer):
        line = line.strip()
        ls = line.split('\t')
        s = ls[0].split('/')[-1].split('.fasta')[0]
        match = 'LK' + ls[1].split('/')[-1].split('_assembly.')[0].split('LK')[1]
        ani = float(ls[2])
        af = float(ls[3])/float(ls[4])
        if ani > epic_best_hits[s][1]:
            epic_best_hits[s] = [match, ani, af]
        if ani == epic_best_hits[s][1]:
            if af > epic_best_hits[s][2]:
                epic_best_hits[s] = [match, ani, af]

smgc_best_hits = defaultdict(lambda: ["NA", 0.0, 0.0])
with open(fastani_smgc_results) as ofsr:
    for i, line in enumerate(ofsr):
        line = line.strip()
        ls = line.split('\t')
        s = ls[0].split('/')[-1].split('.fasta')[0]
        match = ls[1].split('/')[-1].split('.')[0]
        ani = float(ls[2])
        af = float(ls[3])/float(ls[4])
        if ani > smgc_best_hits[s][1]:
            smgc_best_hits[s] = [match, ani, af]
        if ani == smgc_best_hits[s][1]:
            if af > smgc_best_hits[s][2]:
                smgc_best_hits[s] = [match, ani, af]

gtdb_dict = {}
with open(gtdb_results) as ogr:
    for i, line in enumerate(ogr):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        gtdb_dict[ls[0].split('.fna')[0]] = ls[1]

print('\t'.join(['sample', 'MAG quality', 'CheckM2 - completeness', 'CheckM2 - contamination', 'N50 (abyss-fac)', 'Genome Size', 'Distinct tRNAs', 'Distinct rRNAs (max 3)', 'Potentially Novel Species', 'Potentially Novel and Not Matching SMGC or EPIC isolate', 'Matches EPIC isolate at >95.0% ANI and >20% Proportion Fragments Aligned', 'Matches SMGC at >95.0% ANI and >20% Proportion Fragments Aligned', 'GTDB R202', 'closest SMGC hit', 'closest SMGC hit - ANI', 'closest SMGC hit - Proportion Fragments Aligned', 'closest EPIC isolate hit', 'closest EPIC isolate hit - ANI', 'closest EPIC isolate hit - Proportion Fragments Aligned']))

checkm2_dict = {}
with open(checkm2_results) as ocr:
    for i, line in enumerate(ocr):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        samp, comp, cont = ls[:3]
        gs, n50 = abyss_stats[samp]
        dtrnas = len(mg_trnas[samp])
        drrnas = len(mg_rrnas[samp])

        gtdb_tax = gtdb_dict[samp]
        nov_species = False
        if gtdb_tax.endswith('__'):
            nov_species = True

        matches_epic = False
        matches_smgc = False
        
        if epic_best_hits[samp][1] >= 95.0 and epic_best_hits[samp][2] >= 0.2:
            matches_epic = True

        if smgc_best_hits[samp][1] >= 95.0 and smgc_best_hits[samp][2] >= 0.2:
            matches_smgc = True

        nov_species_with_no_match = False
        if nov_species and (not matches_smgc and not matches_epic): 
            nov_species_with_no_match = True

        mag_quality = 'low'
        if float(comp) >= 90.0 and float(cont) <= 5.0 and dtrnas >= 18 and drrnas >= 3 and float(n50) >= 50000:
            mag_quality = 'high'
        elif float(comp) >= 50.0 and float(cont) <= 10.0 and float(n50) >= 10000:
            mag_quality = 'medium'
        print('\t'.join([str(x) for x in [samp, mag_quality, comp, cont, n50, gs, dtrnas, drrnas, nov_species, nov_species_with_no_match, matches_epic, matches_smgc, gtdb_dict[samp], smgc_best_hits[samp][0], smgc_best_hits[samp][1], smgc_best_hits[samp][2], epic_best_hits[samp][0], epic_best_hits[samp][1], epic_best_hits[samp][2]]]))
