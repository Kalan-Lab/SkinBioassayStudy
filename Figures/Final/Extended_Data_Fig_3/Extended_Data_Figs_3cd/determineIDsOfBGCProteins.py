import os
import sys
from Bio import SeqIO
from collections import defaultdict

as_dir = 'antismash/'
for s in os.listdir(as_dir):
    if not s.startswith('LK'): continue
    samp_dir = as_dir + s + '/'
    if not os.path.isdir(samp_dir): continue
    bgc_coords = defaultdict(set)
    for f in os.listdir(samp_dir):
        if f.endswith('.gbk') and '.region' in f: 
            scaff, start, end = [None]*3
            with open(samp_dir + f) as of:
                for line in of:
                    line= line.strip()
                    ls = line.split()
                    if line.startswith('ACCESSION'):
                        scaff = ls[1]
                    elif line.startswith('Orig. start'):
                        start = int(ls[-1])
                    elif line.startswith('Orig. end'):
                        end = int(ls[-1])
            assert(scaff != None and start != None and end != None)
            for pos in range(start+1, end+1):
                bgc_coords[scaff].add(pos)
        
    for f in os.listdir(samp_dir):
        if f.endswith('.gbk') and not '.region' in f:
            with open(samp_dir + f) as of:
                cds_id = 1
                for rec in SeqIO.parse(of, 'genbank'):
                    scaff = rec.id
                    for feat in rec.features:
                        if not feat.type == 'CDS': continue
                        prot_seq = feat.qualifiers.get('translation')[0]
                        prot_start = feat.location.start
                        prot_end = feat.location.end
                        coord_set = set(list(range(prot_start, prot_end)))
                        overlap = False
                        # bgc proteins are regarded as those in which more than >50% of gene is in BGC region coords
                        if len(bgc_coords[scaff].intersection(coord_set))/len(coord_set) > 0.5:
                            overlap = True
                        if overlap:
                            print(s + '|CDS_' + str(cds_id))
                        cds_id += 1
