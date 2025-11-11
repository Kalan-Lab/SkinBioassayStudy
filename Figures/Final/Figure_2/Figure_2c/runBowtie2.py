import os
import sys

read_dir = os.path.abspath('../FastqPair_Sorted_Processed_Reads/') + '/'
results_dir = os.path.abspath(sys.argv[1]) + '/'

bowtie2_reference = sys.argv[2]
bowtie2_cpus = 40

for f in os.listdir(read_dir):
    if f.endswith('_R1.fastq.paired.fq.gz'):
        r1 = read_dir + f
        r2 = read_dir + f.replace('_R1.fastq.paired.fq.gz', '_R2.fastq.paired.fq.gz')
        if os.path.isfile(r1) and os.path.isfile(r2):
            s = f.replace('_R1.fastq.paired.fq.gz', '')
            res_file = results_dir + s + '.txt'
            sam_file = results_dir + s + '.sam'

            bowtie2_cmd = ['bowtie2', '--very-sensitive-local', '--no-unal', '-a', '-x', bowtie2_reference, '-U', r1 + ',' + r2, '-S', sam_file, '-p', str(bowtie2_cpus), '&>', res_file]
            rm_cmd = ['rm', '-f', sam_file]
            
            print(' '.join(bowtie2_cmd + [';'] + rm_cmd))
