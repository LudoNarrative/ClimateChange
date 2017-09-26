

import subprocess
import json
import collections
import random
import sys

def solve(*args):
    """Run clingo with the provided argument list and return the parsed JSON result."""
    
    args = ['clingo','--outf=2']+args[0]
    print args
    print ' '.join(args)
    clingo = subprocess.Popen(
        ' '.join(args),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True
        )
    out, err = clingo.communicate()
    if err:
        print err
    return parse_json_result(out)
def parse_json_result(out):
    """Parse the provided JSON text and extract a dict
    representing the predicates described in the first solver result."""

    result = json.loads(out)
    
    if  len(result['Call']) <= 0:
        return False
    if 'Witnesses' not in result['Call'][0]:
        return False
    if len(result['Call'][0]['Witnesses']) <= 0:
        return False
    
    return True
    

if __name__ == '__main__':

    modifiable = sys.argv[1]
    args = sys.argv[2:]
    
    text = open(modifiable).read()
    rules = text.split('.')
    passes = False
    minVal = 0
    maxVal = len(rules)
    
    ruleCounter = (minVal + maxVal)/2
    best = minVal
    
    passes = solve([modifiable]+args)
    if passes:
        print 'PASSES'
        exit()
    while ruleCounter != minVal and ruleCounter != maxVal:
        print ruleCounter
        with open('mod.lp','w') as modfile:
            modfile.write('.'.join(rules[:ruleCounter])+'.')
        sys.stdout.flush()
        print ['mod.lp'] + args
        passes = solve(['mod.lp'] + args)
        if passes:
            minVal = ruleCounter
            best = minVal
        else:
            maxVal = ruleCounter
        ruleCounter = (minVal + maxVal)/2
    
        print rules[minVal]
        with open('mod.lp','w') as modfile:
            modfile.write('.'.join(rules[:minVal+1])+'.')
        
