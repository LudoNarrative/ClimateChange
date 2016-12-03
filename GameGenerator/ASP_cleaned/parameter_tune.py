import json
import collections
import subprocess
import random
import sys
import numpy as np
from deap import base
from deap import creator
from deap import tools


def create_generator(free_vars,var_map):
    import itertools
    somelists = []
    for var in free_vars:
        somelists.append(var_map[var[0]])
    return itertools.product(*somelists)

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

    #CLINGO = "clingo"
    #args = ["level-core.lp", "level-style.lp", "level-sim.lp"]

    clingo = subprocess.Popen(
        "clingo {} --outf=2".format(' '.join(sys.argv[1:])),
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    out, err = clingo.communicate()
    if err:
        print err

    out = parse_json_result(out)
    resources = []
    for resource in out['resource']:
        
        resources.append(prettify(resource[0]['terms'][0]))
    initializations = {}   
    for initialization in out['initialize']:
        initialization = initialization[0]
        terms = initialization['terms'][0]
        if 'set' == terms['predicate']:
            initializations[prettify(terms['terms'][0])] = [int(terms['terms'][1]['predicate'])]

            
    free_variables = []
    for resource in resources:
        if resource not in initializations:
            free_var = [0]
            initializations[resource] = free_var
            free_variables.append(['initialization',free_var])
            
            
    preconditions = {}
    replacements = {}
    for precondition in out['precondition']:
        
        precondition = precondition[0]
        terms = precondition['terms']
        outcome = prettify(terms[1])
        if outcome not in preconditions:
            preconditions[outcome] = {}
            preconditions[outcome]['compare'] = []
            preconditions[outcome]['other'] = []
        if 'compare' == terms[0]['predicate']:
            direction  = prettify(terms[0]['terms'][0])
            resource   = prettify(terms[0]['terms'][1])
            free_var = [0]
            replacements[prettify(precondition)] = ('precondition',outcome,direction,resource,free_var)
            preconditions[outcome]['compare'].append( (direction,resource,free_var))
            free_variables.append(['condition',free_var])
        else:
            preconditions[outcome]['other'].append( prettify(terms[0]))
    results = {}
  
    free_action_variables = []
    for result in out['result']:
        
        result = result[0]
        terms = result['terms']
        outcome = prettify(terms[0])
        if outcome not in results:
            results[outcome] = {}
            results[outcome]['modify'] = []
            results[outcome]['other'] = []
        if 'modify' == terms[1]['predicate']:
            direction  = prettify(terms[1]['terms'][0])
            resource   = prettify(terms[1]['terms'][1])
            free_var = [1]
            replacements[prettify(result)] = ('result',outcome,direction,resource,free_var)
            results[outcome]['modify'].append( (direction,resource,free_var))
            free_variables.append(['action',free_var])
        else:
            results[outcome]['other'].append(prettify(terms[1]))
    var_generator = create_generator(free_variables,{'initialization':[0,5,10],'condition':[0,1,3,5,10],'action':[1,2,5]})
    comparators = {'ge':lambda x,y: x >= y,
                   'le':lambda x,y: x <= y}
    modifiers = {'increase': lambda x,y:  x+y,
                 'decrease': lambda x,y:  x-y}
    random_odds =0.5#$9
    simulation_count = 40
    depth = 6
    display = False
    creator.create("FitnessMax", base.Fitness, weights=(1.0,))
    creator.create("Individual", list, fitness=creator.FitnessMax)

    toolbox = base.Toolbox()
    def rand_range(min_,max_):
        def gen():
            return random.randrange(min_,max_)
        return gen
    
    toolbox.register("attr_int", rand_range(0,10))
    toolbox.register("individual", tools.initRepeat, creator.Individual,
                     toolbox.attr_int, n=len(free_variables))
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)
    def evaluate(individual):
        state = { r:v for r,v in initializations.items()}
        for free_var,set_var in zip(free_variables,individual):
            free_var[1][0] = set_var
        
        next_state = {}
        fitness = 0
        outcome_reached = set()
        earliest_reached = {}
        latest_reached  = {}
        for simulations in range(simulation_count):
            state = { r:v[0] for r,v in initializations.items()}
            this_run = set()
            for timestep in range(depth):
                for s,v in state.items():
                    next_state[s] = v

                for outcome in preconditions:
                    outcome_fails = False
                    for condition in preconditions[outcome]['compare']:
                        if not comparators[condition[0]](state[condition[1]], condition[2][0]):
                            outcome_fails = True
                    
                    if len( preconditions[outcome]['other']) > 0:
                        rand_fail = random.random() > random_odds
                        outcome_fails = outcome_fails or rand_fail
                    for condition in preconditions[outcome]['other']:
                        if 'tick' == condition:
                            outcome_fails = False
                        
                    if not outcome_fails:
                        outcome_reached.add(outcome)
                        this_run.add(outcome)
                        if outcome not in earliest_reached:
                            earliest_reached[outcome] = float('inf')
                        earliest_reached[outcome] = min(timestep,earliest_reached[outcome])
                        if outcome not in latest_reached:
                            latest_reached[outcome] = float('-inf')
                        latest_reached[outcome] = max(timestep,latest_reached[outcome])
                        
                        for action in results[outcome]['modify']:
                           
                            next_state[action[1]] = modifiers[action[0]](next_state[action[1]],action[2][0])
                for s,v in next_state.items():
                    state[s] = v
            
            for outcome in this_run:
                for action in results[outcome]['other'] + results[outcome]['modify']:
                    if 'game_loss' in action:
                        loss_weight = 0.1
                        fitness += loss_weight
        for outcome in results:
            if outcome not in latest_reached:
                latest_reached[outcome] = depth*2
            if outcome not in earliest_reached:
                earliest_reached[outcome] = depth*2

        outcome_weight = 1000
        fitness += outcome_weight*(len(outcome_reached)-len(preconditions))
        total_end = 0
        end_count = 0
        total_other = 0
        other_count = 0
        earliest_end = float('inf')
        latest_other = float('-inf')
        for outcome in results:
            for action in results[outcome]['other'] + results[outcome]['modify']:
                if 'game_win' in action or 'game_loss' in action:
                    #want game_win and loss to come at end
                    total_end += earliest_reached[outcome]
                    end_count += 1
                    earliest_end = min(earliest_end,earliest_reached[outcome])
                else:
                    total_other += latest_reached[outcome]
                    other_count += 1
                    latest_other = max(latest_other,latest_reached[outcome])
        
        if end_count > 0 and other_count > 0:
            avg_end_weight = 1
            earliest_latest_weight = 30
            fitness += avg_end_weight*(float(total_end)/float(end_count)-float(total_other)/float(other_count))
            
            fitness += earliest_latest_weight*(earliest_end-latest_other)
           
        return fitness,

    toolbox.register("mate", tools.cxTwoPoint)
    toolbox.register("mutate", tools.mutGaussian, mu=2, sigma=4, indpb=0.1)
    toolbox.register("select", tools.selTournament, tournsize=3)
    toolbox.register("evaluate", evaluate)
    def checkBounds(min, max):
        def decorator(func):
            def wrapper(*args, **kargs):
                offspring = func(*args, **kargs)
                for child in offspring:
                    for i in xrange(len(child)):
                        if child[i] > max:
                            child[i] = max
                        elif child[i] < min:
                            child[i] = min
                        child[i] = np.round(child[i]*10.)/10.
                return offspring
            return wrapper
        return decorator
    
    toolbox.decorate("mate", checkBounds(0.1, 10))
    toolbox.decorate("mutate", checkBounds(0.1, 10))
    pop = toolbox.population(n=50)
    CXPB, MUTPB, NGEN = 0.5, 0.2, 40

    # Evaluate the entire population
    fitnesses = map(toolbox.evaluate, pop)
    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    for g in range(NGEN):
        # Select the next generation individuals
        offspring = toolbox.select(pop, len(pop))
        # Clone the selected individuals
        offspring = map(toolbox.clone, offspring)

        # Apply crossover and mutation on the offspring
        for child1, child2 in zip(offspring[::2], offspring[1::2]):
            if random.random() < CXPB:
                toolbox.mate(child1, child2)
                del child1.fitness.values
                del child2.fitness.values

        for mutant in offspring:
            if random.random() < MUTPB:
                toolbox.mutate(mutant)
                del mutant.fitness.values

        # Evaluate the individuals with an invalid fitness
        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
        fitnesses = map(toolbox.evaluate, invalid_ind)
        for ind, fit in zip(invalid_ind, fitnesses):
            ind.fitness.values = fit

        # The population is entirely replaced by the offspring
        pop[:] = offspring
    best = float('-inf')
    best_ind = None
    for ind,fit in zip(pop, map(toolbox.evaluate,pop)):
        if fit > best:
            best = fit
            best_ind = ind
    print best
    for free_var,set_var in zip(free_variables,best_ind):
        free_var[1][0] = set_var
    print 'PRECONDITIONS'
    print preconditions
    print 'RESULTS'
    print results
    

    
    for o in ['entity','resource','singular','many','overlapLogic','initialize', 'goal','controlLogic','static','timer']:
        for oo in out[o]:
            for ooo in oo:
                print prettify(ooo)+'.'
        if len(out[o]) > 0:
            print ''
    outcome2precond = {}
    replace_precondition = {}
    for resource,initialization in initializations.items():
        print 'initialize(set({},{})).'.format(resource,initialization[0])
    print ''
    
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
                if prettify(precond) in replacements:
                    repl = replacements[prettify(precond)]
                    #('precondition',outcome,direction,resource,free_var)
                    print 'precondition(compare({},{},{}),{}).'.format(repl[2],repl[3],repl[4][0],repl[1])
                else:
                    print prettify(precond)+'.'
            if outcome in outcome2result:
                for result in outcome2result[outcome]:
                    if prettify(result) in replacements:
                        repl = replacements[prettify(result)]
                        print 'result({},modify({},{},{})).'.format(repl[1],repl[2],repl[3],repl[4][0])
                    else:
                        print prettify(result)+'.'
            print ''
    for outcome in collidesOutcome:
        for precond in outcome2precond[outcome]:
            print prettify(precond)+'.'
        if outcome in outcome2result:
            for result in outcome2result[outcome]:
                if prettify(result) in replacements:
                    repl = replacements[prettify(result)]
                    print 'result({},modify({},{},{})).'.format(repl[1],repl[2],repl[3],repl[4][0])
                else:
                    print prettify(result)+'.'
        print ''
    

    for o in ['reading']:
        for oo in out[o]:
            for ooo in oo:
                print prettify(ooo)+'.'
        if len(out[o]) > 0:
            print ''
