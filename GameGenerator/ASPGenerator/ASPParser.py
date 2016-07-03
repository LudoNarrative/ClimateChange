


import subprocess
import json
import collections
import random
import sys

def solve(*args):
    """Run clingo with the provided argument list and return the parsed JSON result."""
    args = ['clingo','--outf=2']+list(args)
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

def solve_randomly(*args):
    """Like solve() but uses a random sign heuristic with a random seed."""
    args = list(args[0]) + ["--sign-def=3","--seed="+str(random.randint(0,1<<30))]
    return solve(*args)     
def parse_terms(arguments):
    terms = []
    while len(arguments) > 0:
        l_paren = arguments.find('(')
        r_paren = arguments.find(')')
        comma = arguments.find(',')
        if l_paren < 0:
            l_paren = len(arguments)-1
        if r_paren < 0:
            r_paren = len(arguments)-1
        if comma < 0:
            comma = len(arguments)-1
        next = min(l_paren,r_paren,comma)
        next_c = arguments[next]
        if next_c == '(':
        
            pred = arguments[:next]
            sub_terms, arguments = parse_terms(arguments[next+1:]) 
            terms.append({'predicate':pred,'terms':sub_terms})
        elif next_c == ')':
            pred = arguments[:next]
            if pred != '':
                terms.append({'predicate':arguments[:next]})
            arguments = arguments[next+1:]
            return terms,arguments
        elif next_c == ',':
            pred = arguments[:next]
            if pred != '':
                terms.append({'predicate':arguments[:next]})
            arguments = arguments[next+1:]
        else:
            terms.append({'predicate':arguments})
            arguments = ''
    return terms, ''
            
# def parse_atom(atom):
    # if '(' in atom:
        # left = atom.find('(')
        # predicate  = atom[:left]
        # rest = atom[left+1:-1]
        # tok = ''
        # for char in rest:
             
        # return {'predicate':predicate, 'terms':terms}
    # else:
        # return {'predicate':atom}
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
    
    preds = collections.defaultdict(list)
    env = identitydefaultdict()
    
    for atom in witness:
        parsed,dummy = parse_terms(atom)
        preds[parsed[0]['predicate']].append(parsed)
    return preds
def prettify(atom):
    
    s = atom['predicate']
    if 'terms' in atom:
        s += '('
        ts = [prettify(t) for t in atom['terms']]
        s += ','.join(ts)
        s += ')'
    return s
import collections

def hashable(obj):
    if isinstance(obj, collections.Hashable):
        items = obj
    elif isinstance(obj, collections.Mapping):
        items = frozenset((k, hashable(v)) for k, v in obj.iteritems())
    elif isinstance(obj, collections.Iterable):
        items = tuple(hashable(item) for item in obj)
    else:
        raise TypeError(type(obj))

    return items
    
if __name__ == '__main__':

    args = sys.argv[1:]
    if '-s' in args:
        random.seed(int(args[args.index('-s')+1]))
        args = args[:args.index('-s')] + args[args.index('-s')+2:]
        print args
    out = solve_randomly(args)
    
    for o in ['entity','resource','singular','many','overlapLogic','initialize', 'goal']:
        for oo in out[o]:
            for ooo in oo:
                print prettify(ooo)
        if len(out[o]) > 0:
            print ''
    outcome2precond = {}
    for precond in out['precondition']:
        outcome = hashable(precond[0]['terms'][1])
        if outcome not in outcome2precond:
            outcome2precond[outcome] = []
        outcome2precond[outcome].append(precond[0])
    outcome2result = {}
    for result in out['result']:
        outcome = hashable(result[0]['terms'][0])
        if outcome not in outcome2result:
            outcome2result[outcome] = []
        outcome2result[outcome].append(result[0])
    for outcome in sorted(outcome2precond):
        for precond in outcome2precond[outcome]:
            print prettify(precond)
        for result in outcome2result[outcome]:
            print prettify(result)
        print ''
    
