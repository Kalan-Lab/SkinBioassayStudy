import os
import sys

assembly_dir = 'MetaSPAdes_Assembly/'
results_dir = 'MetaSPAdes_Assembly_antiSMASH/'

for s in os.listdir(assembly_dir):
    assembly = assembly_dir + s + '/scaffolds.fasta'
    print('antismash --taxon bacteria --genefinding-tool prodigal-m --fullhmmer -c 4 --output-dir ' + results_dir + s + '/ ' + assembly) 
