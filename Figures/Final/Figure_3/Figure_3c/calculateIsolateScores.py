import os
import sys

bioassay_csv = sys.argv[1]
group = sys.argv[2] 

data = []
with open(bioassay_csv) as obc:
    for line in obc:
        line = line.strip('\n')
        ls = line.split(',')
        data.append(ls[3:])

for ls in zip(*data):
    ls = list(ls)
    sample = ls[0]

    scores = []
    for val in ls[1:]:
        if val == '-1': continue
        scores.append(float(val))
    
    summmary_stat = 'NA'
    num_scores = len(scores)
    if num_scores > 0:
        sum_scores = sum(scores)
        summary_stat = float(sum_scores)/num_scores

    print(group + '\t' + sample + '\t' + str(summary_stat) + '\t' + str(num_scores))
