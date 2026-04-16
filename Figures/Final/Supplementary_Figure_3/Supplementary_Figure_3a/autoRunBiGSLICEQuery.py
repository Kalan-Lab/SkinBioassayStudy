import os
import sys
from collections import defaultdict

antismash_results_dir = os.path.abspath(sys.argv[1]) + '/'
bigfam_db = '/workspace/local/rauf/bigslice_setup/v1/BiG-SLICE/full_run_result/'

for asr in os.listdir(antismash_results_dir):
    print('bigslice --query ' + antismash_results_dir + asr + ' --n_ranks 10 ' + bigfam_db) 
    
