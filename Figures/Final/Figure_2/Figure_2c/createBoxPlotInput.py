import os
import sys
from collections import defaultdict

dir1 = 'Bowtie2_Mappings_SBCC/'
dir2 = 'Bowtie2_Mappings_SBCC_with_Cacnes/'
dir3 = 'Bowtie2_Mappings_SBCC_with_Cacnes_and_EPIC/'
dir4 = 'Bowtie2_Mappings_EPIC/'
dir5 = 'Bowtie2_Mappings_EPIC_and_SMGC/'
dir6 = 'Bowtie2_Mappings_EPIC_with_Cacnes/'
metagenome_info = 'metagenome_info.txt'

data1 = {}
for f in os.listdir(dir1):
    mg = f.split('.')[0].replace('_', '-')
    with open(dir1 + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data1[mg] = line.split('% overall alignment rate')[0]

data2 = {}
for f in os.listdir(dir2):
    mg = f.split('.')[0].replace('_', '-')
    with open(dir2 + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data2[mg] = line.split('% overall alignment rate')[0]

data3 = {}
for f in os.listdir(dir3):
    mg = f.split('.')[0].replace('_', '-')
    with open(dir3 + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data3[mg] = line.split('% overall alignment rate')[0]

data4 = {}
for f in os.listdir(dir4):
    mg = f.split('.')[0].replace('_', '-')
    with open(dir4 + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data4[mg] = line.split('% overall alignment rate')[0]

data5 = {}
for f in os.listdir(dir5):
    mg = f.split('.')[0].replace('_', '-')
    with open(dir5 + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data5[mg] = line.split('% overall alignment rate')[0]

data6 = {}
for f in os.listdir(dir6):
    mg = f.split('.')[0].replace('_', '-')
    with open(dir6 + f) as odf:
        for line in odf:
            line = line.strip()
            if '% overall alignment rate' in line:
                data6[mg] = line.split('% overall alignment rate')[0]

mgs = set([])
with open(metagenome_info) as osf:
    for line in osf:
        line = line.strip()
        ls = line.split('\t')
        mgs.add(tuple(ls))

print('\t'.join(['metagenome', 'body_site', 'body_site_type', 'database', 'value']))
for mg in mgs:
    print('\t'.join([mg[0], mg[1], mg[2], '2. SBCC', data1[mg[0]]]))
    print('\t'.join([mg[0], mg[1], mg[2], '4. SBCC + C. acnes ATCC 6919', data2[mg[0]]]))
    print('\t'.join([mg[0], mg[1], mg[2], '5. EPIC + SBCC + C. acnes ATCC 6919', data3[mg[0]]]))
    print('\t'.join([mg[0], mg[1], mg[2], '6. EPIC + SMGC', data5[mg[0]]]))
    print('\t'.join([mg[0], mg[1], mg[2], '1. EPIC', data4[mg[0]]]))
    print('\t'.join([mg[0], mg[1], mg[2], '3. EPIC + C. acnes ATCC 6919', data6[mg[0]]]))
