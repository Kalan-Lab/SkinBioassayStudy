import os
import sys
from collections import defaultdict

# Target  Isolate SummmaryScore   NumberTested    IsolateGenus    IsolatePhylum
panel_genus = defaultdict(lambda: defaultdict(int))
with open('Boxplot_Input.txt') as obif:
    for i, line in enumerate(obif):
        line = line.strip()
        ls = line.split('\t')
        if i == 0:
            continue
        else:
            panel = ls[0]
            genus = ls[-2]
            iso = ls[1]
            panel_genus[panel][genus] += 1

with open('Boxplot_Input.txt') as obif:
    for i, line in enumerate(obif):
        line = line.strip()
        ls = line.split('\t')
        if i == 0:
            print('\t'.join(ls + ['IsolateGenus_with_SampleSize']))
        else:
            panel = ls[0]
            genus = ls[-2]
            iso = ls[1]
            tot_f = panel_genus['Fungal'][genus]
            tot_gp = panel_genus['Gram Positive'][genus]
            tot_gn = panel_genus['Gram Negative'][genus]
            
            # always true!
            assert(tot_f == tot_gp and tot_gp == tot_gn)
            
            genus_new_name = genus + ' (n=' + str(tot_f) + ')'
            print(line + '\t' + genus_new_name)
