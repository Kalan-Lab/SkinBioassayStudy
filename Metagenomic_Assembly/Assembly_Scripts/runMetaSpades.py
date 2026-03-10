import os
import sys

read_dir = 'FastqPair_Sorted_Processed_Reads/'
metaspades_dir = 'MetaSPAdes_Assembly/'
threads = 20

for f in os.listdir(read_dir):
    if not f.endswith('_R1.fastq.paired.fq.gz'): continue
    r1 = read_dir + f
    r2 = read_dir + f.replace('_R1.fastq.paired.fq.gz', '_R2.fastq.paired.fq.gz')
    res_dir = metaspades_dir + f.split('_R1.fastq.paired.fq.gz')[0] + '/'
    print('metaspades.py -1 %s -2 %s -o %s -t %d --only-assembler' % (r1, r2, res_dir, threads))
