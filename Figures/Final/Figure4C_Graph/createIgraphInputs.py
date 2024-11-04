import os
import sys
from collections import defaultdict

lk_gcf_file = 'LK_GCFs.txt'
bgc_data_file = 'BGC_Centric_View.txt'
gcf_data_file = 'GCF_Centric_View.txt'
net_file = 'mix_c0.30.network'

lk_gcfs = set([])
with open(lk_gcf_file) as olgf:
    for line in olgf:
        line = line.strip()
        lk_gcfs.add(line)

node_outf = open('nodes.txt', 'w')
edge_outf = open('edges.txt', 'w')
pie_outf = open('pie.txt', 'w')

node_outf.write('node\tnum_samples\tlabel\n')
edge_outf.write('from\tto\tweight\n')

node_to_size = {}
nodes = []
lk = []
smgc = []
mibig = []
with open(gcf_data_file) as ogdf:
    for line in ogdf:
        line = line.strip()
        ls = line.split('\t')
        if not ls[0] in lk_gcfs: continue
        if int(ls[6]) == 1:
            size = 1
        elif int(ls[6]) >= 2 and int(ls[6]) <= 10:
            size = 2
        elif int(ls[6]) >= 10:
            size = 3
        node_to_size[ls[0]] = size
        nodes.append(ls[0])
        lk.append(ls[7])
        smgc.append(ls[8])
        mibig.append(ls[9])

pie_outf.write('col\t' + '\t'.join(nodes) + '\n')
pie_outf.write('LK\t' + '\t'.join(lk) + '\n')
pie_outf.write('MIBiG\t' + '\t'.join(mibig) + '\n')
pie_outf.write('SMGC\t' + '\t'.join(smgc) + '\n')
pie_outf.close()

annot_gcfs = defaultdict(set)
gcf_annots = defaultdict(set)
with open(bgc_data_file) as odf:
    for line in odf:
        line = line.strip('\n')
        ls = line.split('\t')
        gcf = ls[9]
        if not gcf in lk_gcfs: continue
        for annot in ls[8].split('; '):
            annot_gcfs[annot].add(gcf)
            gcf_annots[gcf].add(annot)

node_label = defaultdict(lambda: '')
for an in annot_gcfs:
    flag = False
    for i, g1 in enumerate(sorted(annot_gcfs[an])):
        if not flag:
            if len(gcf_annots[g1]) == 1 and len(annot_gcfs[an]) >= 5:
                node_label[g1] = an
                flag = True
        for j, g2 in enumerate(sorted(annot_gcfs[an])):
            if i < j:
                g1_ans = len(gcf_annots[g1])
                g2_ans = len(gcf_annots[g2])
                weight = 1.0/max([g1_ans, g2_ans])
                edge_outf.write(g1 + '\t' + g2 + '\t' + str(weight) + '\n')

for n in nodes:
    node_outf.write('\t'.join([n, str(node_to_size[n]), node_label[n]]) + '\n')


edge_outf.close()
node_outf.close()
