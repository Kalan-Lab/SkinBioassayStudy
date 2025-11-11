import os
import sys
from scipy import stats

stost = {'Alar crease': 'Sebaceous', 'Antecubital fossa': 'Dry', 'Back': 'Sebaceous', 'Nares': 'Moist', 'Occiput': 'Sebaceous', 'Toe web space': 'Moist', 'Umbilicus': 'Moist', 'Volar forearm': 'Dry'}

had_prop = {}
with open('EPIC_Isolate_HAD_Protein_Proportions.txt') as of:
    for line in of:
        line = line.strip()
        ls = line.split('\t')
        had_prop[ls[0]] = float(ls[1])

dry = []
other = []
print('site_type\thad_proportion')
with open('sample_site_info.txt') as of:
    for i, line in enumerate(of):
        if i == 0: continue
        line = line.strip()
        ls = line.split('\t')
        if ls[0] in had_prop:
            site = ls[5]
            site_type = stost[site]
            if site_type == 'Dry':
                print('dry\t' + str(had_prop[ls[0]]))
                dry.append(had_prop[ls[0]])
            elif site_type == 'Moist':
                print('moist\t' + str(had_prop[ls[0]]))
                other.append(had_prop[ls[0]])
            elif site_type == 'Sebaceous':
                print('sebaceous\t' + str(had_prop[ls[0]]))
                other.append(had_prop[ls[0]])

print(stats.ranksums(dry, other, alternative='less'))
