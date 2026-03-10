import os
import sys

read_dir = 'FastqPair_Sorted_Processed_Reads/'
rename_read_dir = 'Uncompressed_and_Renamed_Reads/'
assembly_dir = 'MetaSPAdes_Assembly/'
binning_dir = 'Metaspades_MetaWrap_Binning/'
refinement_dir = 'Metaspades_MetaWrap_Refinement/'
threads = 10
max_mem = 64

for i, f in enumerate(os.listdir(read_dir)):
    if not f.endswith('_R1.fastq.paired.fq.gz'): continue
    s = f.replace('_R1.fastq.paired.fq.gz', '')
    r1 = read_dir + f
    r2 = read_dir + s + '_R2.fastq.paired.fq.gz'
    res_bin_dir = binning_dir + s + '/'
    ref_bin_dir = refinement_dir + s + '/'
    
    if os.path.isdir(ref_bin_dir): continue
    if not os.path.isfile(r1) and not os.path.isfile(r2): continue
    cp_cmd = ['cp', r1, r2, rename_read_dir]
    os.system(' '.join(cp_cmd))

    gunzip_cmd = ['unpigz', '-p', '50', rename_read_dir + r1.split('/')[-1], rename_read_dir + r2.split('/')[-1]]
    os.system(' '.join(gunzip_cmd))

    gun_r1 = rename_read_dir + r1.split('/')[-1][:-3]
    gun_r2 = rename_read_dir + r2.split('/')[-1][:-3]

    assert (os.path.isfile(gun_r1) and os.path.isfile(gun_r2))

    ren_r1 = rename_read_dir + s + '_1.fastq'
    ren_r2 = rename_read_dir + s + '_2.fastq'

    os.system('mv ' + gun_r1 + ' ' + ren_r1)
    os.system('mv ' + gun_r2 + ' ' + ren_r2)

    assembly_file = assembly_dir + s + '/scaffolds.fasta'
    
    if not os.path.isfile(assembly_file): continue

    con_dir = res_bin_dir + 'concoct_bins/'
    met_dir = res_bin_dir + 'metabat2_bins/'
    max_dir = res_bin_dir + 'maxbin2_bins/'

    metawrap_bin_cmd = ['metawrap', 'binning', '--maxbin2', '--metabat2', '--concoct', '-t', str(threads), '-m', str(max_mem), '-a', assembly_file, '-o', res_bin_dir, ren_r1, ren_r2]
    metawrap_bin_refinement_cmd = ['metawrap', 'bin_refinement', '-t', str(threads), '-c', '50', '-x', '10', '-o', ref_bin_dir, '-A', con_dir, '-B', met_dir, '-C', max_dir]
    clean_cmd = ['rm', ren_r1, ren_r2]
    print(' '.join(metawrap_bin_cmd) + '; ' + ' '.join(metawrap_bin_refinement_cmd) + '; ' + ' '.join(clean_cmd))
