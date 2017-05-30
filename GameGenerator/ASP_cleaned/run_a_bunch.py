import sys
import os

filename = sys.argv[1]
to_make = int(sys.argv[2])

args = sys.argv[3:]


for ii in range(1,to_make):
    print ii
    print ('python simulate.py {} -s {} > {}_{}.lp'.format(' '.join(args),ii,filename,ii))
    os.system('python simulate.py {} -s {} > {}_{}.lp'.format(' '.join(args),ii,filename,ii))
    output = []
    with open('{}_{}.lp'.format(filename,ii)) as infile:
        found = False
        for line in infile:
            if '========' in line:
                if found:
                    output.append(line.rstrip())
                found = True
                
            elif found:
                output.append(line.rstrip())
    print '\n'.join(output)
    with open('{}_{}.lp'.format(filename,ii),'wb') as outfile:
        outfile.write('\n'.join(output))
