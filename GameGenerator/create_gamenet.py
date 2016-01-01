import subprocess
import json
import collections
import random
import sys

def solve(*args):
    """Run clingo with the provided argument list and return the parsed JSON result."""
    
    CLINGO = "~/bin/clingo"
    arg = [CLINGO,'petri.lp','knowledge_base.lp', "--outf=2"] + list(args)
    arg = [a for a in arg]
    clingo = subprocess.Popen(
        ' '.join(arg),
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
            functor = atom[:left]
            arg_string = atom[left:]
            try:
                preds[functor].add( eval(arg_string, env) )
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
	if len(sys.argv) != 4:
		print "Usage: {} <scenario file> <threads> <output name>".format(sys.argv[0])
		exit()
	lp_file = sys.argv[1]
	threads = int(sys.argv[2])
	net = solve_randomly(lp_file,'--parallel-mode={}'.format(threads))
	with open(sys.argv[3],'w') as outfile:
		outfile.write('digraph G{\n')

		for s in net['activeSource']:
			outfile.write('{} [shape = box, color = green]\n'.format(s[0]))
			outfile.write('{} -> {}\n'.format(s[1],s[0]))
			outfile.write('{} -> {}\n'.format(s[0],s[1]))
			outfile.write('{} -> {} [color = green]\n'.format(s[0],s[2]))

		for s in net['activeSink']:
			outfile.write('{} [shape = box, color = red]\n'.format(s[0]))
			outfile.write('{} -> {}\n'.format(s[1],s[0]))
			outfile.write('{} -> {}\n'.format(s[0],s[1]))
			outfile.write('{} -> {} [color = red]\n'.format(s[2],s[0]))
		for s in net['activeConverter']:
			outfile.write('{} [shape = box, color = blue]\n'.format(s[0]))
			outfile.write('{} -> {}\n'.format(s[1],s[0]))
			outfile.write('{} -> {} [color = blue]\n'.format(s[0],s[2]))
		outfile.write('}\n')
