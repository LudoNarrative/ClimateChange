import sys
import os

filename = sys.argv[1]
args = sys.argv[2:]


for ii in range(1,26):
    os.system('python simulate.py {} > {}_{}.lp'.format(' '.join(args),filename,ii))
    output = []
    with open('{}_{}.lp'.format(filename,ii)) as infile:
        found = False
        for line in infile:
            if '=' in line:
                if found:
                    output.append(line.rstrip())
                found = True
                
            elif found:
                output.append(line.rstrip())
    
    with open('{}_{}.lp'.format(filename,ii),'wb') as outfile:
        outfile.write('\n'.join(output))
