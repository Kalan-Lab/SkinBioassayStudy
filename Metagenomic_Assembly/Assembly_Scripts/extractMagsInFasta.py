import os
import sys
from Bio import SeqIO
from collections import defaultdict

sample_info_file = '../Bowtie2_Mapping/MetaInfo.txt'
final_bin_dir = 'Metaspades_MetaWrap_Refinement/'
assembly_dir = 'MetaSPAdes_Assembly/'
mag_dir = 'MetaSPAdes_MegaWRAP_MAGs/'

os.system('rm ' + mag_dir + '/*')

mhs_samps = set([])
with open(sample_info_file) as osif:
    for line in osif:
        if line.startswith('#'): continue
        line = line.strip()
        ls = line.split('\t')
        samp = '-'.join(ls[0].split('-')[:-1]) + '_' + ls[0].split('-')[-1]
        mhs_samps.add(samp)

for s in os.listdir(final_bin_dir):
    binning_file = final_bin_dir + s + '/metawrap_50_10_bins.contigs'
    assembly_file = assembly_dir + s + '/scaffolds.fasta'
    if not os.path.isfile(binning_file) or not os.path.isfile(assembly_file): continue
    contig_to_bin = {}
    with open(binning_file) as obf:
        for line in obf:
            line = line.strip()
            contig, binid = line.split('\t')
            contig_to_bin[contig] = binid

    with open(assembly_file) as oaf:
        for rec in SeqIO.parse(oaf, 'fasta'):
            if rec.id in contig_to_bin:
                contig_bin = contig_to_bin[rec.id]
                mag_file = mag_dir + s + '_' + contig_bin + '.fasta'
                mag_handle = open(mag_file, 'a+')
                mag_handle.write('>' + rec.id + '\n' + str(rec.seq) + '\n')
                mag_handle.close()
