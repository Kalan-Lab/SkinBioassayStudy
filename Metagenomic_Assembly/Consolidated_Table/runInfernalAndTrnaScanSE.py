import os
import sys

indir = 'MetaSPAdes_MegaWRAP_MAGs/'
rrna_cm = 'Ribo_16S_23S_and_5S.cm'
infernal_resdir = 'Infernal_Results/'
trnascan_resdir = 'tRNAScan-SE_Results/'

for f in os.listdir(indir):
    s = f.split('.fasta')[0]
    mag_file = indir + f
    infern_outf = infernal_resdir + s + '.txt'
    trnasc_outf = trnascan_resdir + s + '.txt'
    
    # tRNAscan-SE
    trnasc_cmd = ['tRNAscan-SE', '-B', '-q', '-o', trnasc_outf, mag_file]
    #print(' '.join(trnasc_cmd))
    
    # Run INFERNAL cmsearch
    infern_cmd = ['cmsearch', '-Z', '1000', '--hmmonly', '--cut_ga', '--noali', '--tblout', infern_outf, rrna_cm, mag_file]
    print(' '.join(infern_cmd))
