import sqlite3
import sys
import pandas as pd
import os

reports_dir = '/workspace/local/rauf/bigslice_setup/v1/BiG-SLICE/full_run_result/reports/'

# gcf_membership table:     gcf_id  bgc_id  membership_value  rank
# bgc table:    id  name type  on_contig_edge  length_nt  orig_folder  orig_filename 

for run_id in range(2, 807):
    database = reports_dir + str(run_id) + '/data.db'
    if not os.path.isfile(database): continue
    con = sqlite3.connect(database)
    
    bgc_pdf = pd.read_sql_query("SELECT * FROM bgc", con)
    gcf_membership_pdf = pd.read_sql_query("SELECT * FROM gcf_membership", con)
    
    bgc_lol = bgc_pdf.values.tolist()
    gcf_mem_lol = gcf_membership_pdf.values.tolist()

    bgc_info = {}
    for info in bgc_lol:
        bgc_info[info[0]] = [info[-2], info[-1]]

    for info in gcf_mem_lol:
        gcf_id, bgc_id, membership_value, rank = info
        print('\t'.join([str(x) for x in [bgc_id, bgc_info[bgc_id][0], bgc_info[bgc_id][1], gcf_id, membership_value, rank]]))

    con.close()
