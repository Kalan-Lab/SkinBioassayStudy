import os
import sys
from collections import defaultdict

meta_meta_file = 'Metagenomic_Meta_Data.txt'
reads_per_mg_sample = 'total_read_counts_per_sample.txt'
big_map_rpkm_norm_file = sys.argv[1]
big_map_cvg_file = sys.argv[2]

cutoff_rpkm = float(sys.argv[3])
cutoff_cvg = float(sys.argv[4])

map_type = {'Al': 'Sebaceous', 'Ba': 'Sebaceous', 'Oc': 'Sebaceous', 'Af': 'Rarely_Moist', 'Na': 'Moist', 'Tw': 'Moist', 'Um': 'Moist', 'Vf': 'Rarely_Moist'}
mg_reads = {}
with open(reads_per_mg_sample) as orpms:
    for line in orpms:
        line = line.strip()
        ls = line.split('\t')
        reads = float(ls[1])/4.0  
        samp = ls[0]
        mg_reads[samp] = reads

samp_sub = {}
samp_bos = {}
with open(meta_meta_file) as ommf:
    for line in ommf:
        line = line.strip()
        ls = line.split('\t')
        if ls[4] == '2' or ls[3] in set(['Mock', 'Neg', 'NA']): continue
        sub = ls[2]
        bos = ls[3]
        samp_sub[ls[0]] = sub
        if bos in map_type:
            samp_bos[ls[0]] = map_type[bos] + '_' + bos

samples = []
all_bgcs = set([])
bgc_cats = {}
samp_class_rpkm = defaultdict(lambda: defaultdict(float))
with open(big_map_rpkm_norm_file) as obmf:
    for i, line in enumerate(obmf):
        line = line.strip('\n')
        ls = line.split('\t')
        if i == 0: 
            samples = ls[1:]
        else:
            bgc = ls[0]
            bgc_cat = bgc.split('Entryname=')[1].split('--')[0]
            for j, val in enumerate(ls[1:]):
                samp = '-'.join(samples[j].split('-')[:-1]) + '_' + samples[j].split('-')[-1]
                val = float(val)
                samp_class_rpkm[samp][bgc] = val
            all_bgcs.add(bgc)
            bgc_cats[bgc] = bgc_cat

samples = []
samp_class_cvg = defaultdict(lambda: defaultdict(float))
with open(big_map_cvg_file) as obmf:
    for i, line in enumerate(obmf):
        line = line.strip('\n')
        ls = line.split('\t')
        if i == 0:
            samples = ls[1:]
        else:
            bgc = ls[0]
            bgc_cat = bgc.split('Entryname=')[1].split('--')[0]
            for j, val in enumerate(ls[1:]):
                samp = '-'.join(samples[j].split('-')[:-1]) + '_' + samples[j].split('-')[-1]
                val = float(val)
                samp_class_cvg[samp][bgc] = val
            all_bgcs.add(bgc)
            bgc_cats[bgc] = bgc_cat

print('\t'.join(['sample', 'bgc', 'bgc_class', 'rpkm_norm', 'coverage', 'sample_subject', 'sample_bodysite']))
for s in samp_class_rpkm:
    for b in all_bgcs:
        if not s in samp_sub or not s in samp_bos: continue
        if samp_class_rpkm[s][b] >= cutoff_rpkm and samp_class_cvg[s][b] >= cutoff_cvg:
            print('\t'.join([str(x) for x in [s, '"' + b + '"', bgc_cats[b], samp_class_rpkm[s][b], samp_class_cvg[s][b], samp_sub[s], samp_bos[s]]]))
