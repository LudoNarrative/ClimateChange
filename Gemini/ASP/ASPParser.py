


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
    with open('dump.lp','w') as outfile:
        result = json.loads(out)
        witness = result['Call'][0]['Witnesses'][0]['Value']
        for atom in sorted(witness):
            outfile.write(atom +'\n')
            
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
    
    for o in ['entity','resource','singular','many','overlapLogic','initialize', 'goal','controlLogic','static','timer']:
        for oo in out[o]:
            for ooo in oo:
                print prettify(ooo)+'.'
        if len(out[o]) > 0:
            print ''
    outcome2precond = {}
    replace_precondition = {}
    for result in out['replace_precondition']:
        outcome = hashable(result[0]['terms'][0])
        if outcome not in replace_precondition:
            replace_precondition[outcome] = {}
        replace_precondition[outcome][prettify(result[0]['terms'][1])] = result[0]['terms'][2]
    
    for precond in out['precondition']:
        if precond[0]['terms'][0]['predicate'] == 'overlaps' and  len(precond[0]['terms'][0]['terms']) == 1:
            continue
        outcome = hashable(precond[0]['terms'][1])
        if outcome not in outcome2precond:
            outcome2precond[outcome] = []
        if outcome in replace_precondition:

            if prettify(precond[0]['terms'][0]) in replace_precondition[outcome]:
                precond[0]['terms'][0] = replace_precondition[outcome][prettify(precond[0]['terms'][0])]
        outcome2precond[outcome].append(precond[0])
        
    collidesOutcome = []
    for outcome in outcome2precond:
        collides = -1
        overlaps = -1
        for ii,precond in enumerate(outcome2precond[outcome]):
            temp = prettify(precond)
            if 'collide' in temp:
                collides = ii
            if 'overlaps' in temp:
                overlaps = ii
        if collides != -1:
            outcome2precond[outcome].pop(overlaps)
            collidesOutcome.append(outcome)
            
    outcome2result = {}
    every_frames = set()
    for every_frame in out['every_frame']:
        every_frame = every_frame[0]
        every_frames.add(every_frame['terms'][0]['predicate'])
  
    replace = {}    
    for result in out['replace']:
        continue
        outcome = hashable(result[0]['terms'][0])
        if result[0]['terms'][2]['predicate'] ==  'increase' and result[0]['terms'][0]['predicate'] in every_frames:
            result[0]['terms'][1]['predicate'] = 'increase_over_time'
            result[0]['terms'][2]['predicate'] = 'increase_over_time'
            #print ':',result[0]
            pass
        if result[0]['terms'][2]['predicate'] ==  'decrease' and result[0]['terms'][0]['predicate'] in every_frames:
            result[0]['terms'][1]['predicate'] = 'decrease_over_time'
            result[0]['terms'][2]['predicate'] = 'decrease_over_time'
            pass
            #print ':',result[0]
        if outcome not in replace:
            replace[outcome] = {}

        replace[outcome][prettify(result[0]['terms'][1])] = result[0]['terms'][2]
        #replace[outcome].append(result[0])
    for result in out['result']:
        outcome = hashable(result[0]['terms'][0])
        if outcome not in outcome2result:
            outcome2result[outcome] = []
        
        if result[0]['terms'][1]['predicate'] ==  'increase' and result[0]['terms'][0]['predicate'] in every_frames:
            result[0]['terms'][1]['predicate'] = 'increase_over_time'
            #print ':',result[0]
            pass
        if result[0]['terms'][1]['predicate'] ==  'decrease' and result[0]['terms'][0]['predicate'] in every_frames:
            result[0]['terms'][1]['predicate'] = 'decrease_over_time'
            pass
            #print ':',result[0]
        if outcome in replace:
            if prettify(result[0]['terms'][1]) in replace[outcome]:
                result[0]['terms'][1] = replace[outcome][prettify(result[0]['terms'][1])]

        outcome2result[outcome].append(result[0])
    for outcome in sorted(outcome2precond):
        if outcome not in collidesOutcome:
            for precond in outcome2precond[outcome]:
                print prettify(precond)+'.'
            if outcome in outcome2result:
                for result in outcome2result[outcome]:
                    print prettify(result)+'.'
            print ''
    for outcome in collidesOutcome:
        for precond in outcome2precond[outcome]:
            print prettify(precond)+'.'
        if outcome in outcome2result:
            for result in outcome2result[outcome]:
                print prettify(result)+'.'
        print ''
    

    for o in ['reading']:
        for oo in out[o]:
            for ooo in oo:
                print prettify(ooo)+'.'
        if len(out[o]) > 0:
            print ''
