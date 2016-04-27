import subprocess
import json
import collections
import random
import sys

def solve(*args):
    """Run clingo with the provided argument list and return the parsed JSON result."""
    
    clingo = subprocess.Popen(
        ' '.join(args[0]),
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
    
    assert len(result['Call']) > 0
    assert len(result['Call'][0]['Witnesses']) > 0
    
    witness = result['Call'][0]['Witnesses'][0]['Value']
    
    class identitydefaultdict(collections.defaultdict):
        def __missing__(self, key):
            return key
    
    preds = collections.defaultdict(set)
    env = identitydefaultdict()
    
    for atom in witness:
        if '(' in atom:
            left = atom.index('(')
            right = atom.rindex(')')
            functor = atom[:left]
            arg_string = atom[left:]
            try:
                preds[functor].add( arg_string)
            except TypeError:
                pass # at least we tried...
            
        else:
            preds[atom] = True
    
    return dict(preds)
def solve_randomly(*args):
    """Like solve() but uses a random sign heuristic with a random seed."""
    args = list(args) + ["--sign-def=3","--seed="+str(random.randint(0,1<<30))]
    return solve(*args) 


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print "Usage: {} args".format(sys.argv[0])
        exit()
    out = solve(sys.argv[1:])
    
    preconditionsOfResult = {}
    for precondition in out['precondition']:
        condition = precondition
        
        result = condition[condition.rindex(',')+1:-1]
        if result not in preconditionsOfResult:
            preconditionsOfResult[result] = []
        preconditionsOfResult[result].append(condition[1:condition.rindex(',')])
    actionsOfResult = {}
    
    for precondition in out['result']:
        condition = precondition
        result = condition[1:condition.index(',')]
        effect = condition[condition.index(',')+1:-1]
        if result not in actionsOfResult:
            actionsOfResult[result] = []
        actionsOfResult[result].append(effect)
        
    for outcome in sorted(preconditionsOfResult):
        for precondition in preconditionsOfResult[outcome]:
            print 'precondition({},{})'.format(precondition,outcome)
        for action in actionsOfResult[outcome]:
            print 'result({},{})'.format(outcome,action)
        print '\n'
            