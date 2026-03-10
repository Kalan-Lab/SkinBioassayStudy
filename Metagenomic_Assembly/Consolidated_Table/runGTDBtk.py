import os
import sys

# GTDBtk (v1.7.0) with GTDB R202 was used for this study.

ref_list_file = sys.argv[1]
outdir = os.path.abspath(sys.argv[2]) + '/'

in_dir = outdir + 'genomes/'
id_dir = outdir + 'identify/'
al_dir = outdir + 'align/'
cl_dir = outdir + 'classify/'

os.system('mkdir ' + ' '.join([outdir, in_dir, id_dir, al_dir, cl_dir]))

for line in open(ref_list_file):
    line = line.strip()
    os.system('cp ' + line + ' ' + in_dir + line.split('/')[-1].split('.fasta.gz')[0] + '.fna.gz')

os.system('gtdbtk identify --genome_dir ' + in_dir + ' --out_dir ' + id_dir + ' --extension gz --cpus 50')
os.system('gtdbtk align --identify_dir ' + id_dir + ' --out_dir ' + al_dir + ' --cpus 50')
os.system('gtdbtk classify --genome_dir ' + in_dir + ' --align_dir ' + al_dir + ' --out_dir ' + cl_dir + ' -x gz --cpus 1')
