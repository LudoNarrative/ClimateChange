import json
import collections
import subprocess
import random
import sys
import numpy as np
from math import *
from deap import base
from deap import creator
from deap import tools

comparators = {'ge':lambda x,y: x >= y,
               'le':lambda x,y: x <= y}
modifiers = {'increase': lambda x,y:  x+y,
             'decrease': lambda x,y:  x-y}

def solve(*args):
    """Run clingo with the provided argument list and return the parsed JSON result."""
    print_args =  ['clingo']+list(args) + [' | tr [:space:] \\\\n | sort ']
    args = ['clingo','--outf=2']+list(args)

    
    print ' '.join(print_args)
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



def parse_game(result):
    resources = []

    
    for resource in result['resource']:        
        resources.append(prettify(resource[0]['terms'][0]))


    timers = {}
    for timer in result['timer_logic']:
        name = prettify(timer[0]['terms'][0])
        time = int(prettify(timer[0]['terms'][1]['terms'][0]))
        timers[name] = time



    entities = []
    for entity in result['entity']:        
        entities.append(prettify(entity[0]['terms'][0]))
    initializations = {}
    adds = {}
    settings = []   
    for initialization in result['initialize']:
        initialization = initialization[0]
        terms = initialization['terms'][0]
        if 'set' == terms['predicate']:
            settings.append(('initialize',prettify(terms['terms'][0]),[int(terms['terms'][1]['terms'][0]['predicate'])],'set'))
        if 'add' in terms['predicate']:
            if prettify(terms['terms'][0]) not in adds:
                adds[prettify(terms['terms'][0])] = 0
            adds[prettify(terms['terms'][0])] += int(terms['terms'][1]['terms'][0]['predicate'])
    for add in adds:
        settings.append(('initialize',add,[adds[add]],'add',''))
    free_variables = []
    
    for resource in resources:
        if resource not in initializations:
            free_var = [0]
            free_variables.append(['initialize',free_var,resource])
            settings.append(('initialize',resource,free_var,'set'))
            
    for entity in entities:
        if entity not in initializations:
            free_var = [0]
            
            free_variables.append(['initialize',free_var,entity])
            settings.append(('initialize',entity,free_var,'add'))
            
    rules = {}
    replacements = {}
    for precondition in result['precondition']:
        
        precondition = precondition[0]
        terms = precondition['terms']
        outcome = prettify(terms[1])
        if outcome not in rules:
            rules[outcome] = {}
            rules[outcome]['preconditions'] = {}
            rules[outcome]['preconditions']['compare'] = []
            rules[outcome]['preconditions']['other'] = []
            rules[outcome]['preconditions']['overlaps'] = []
            rules[outcome]['preconditions']['timer_elapsed'] = []
            rules[outcome]['results'] = {}
            rules[outcome]['results']['modify'] = []
            rules[outcome]['results']['other'] = []
            rules[outcome]['results']['add'] = []
            rules[outcome]['results']['delete'] = []
        if 'compare' == terms[0]['predicate']:
            direction  = prettify(terms[0]['terms'][0])
            resource   = prettify(terms[0]['terms'][1])
            free_var = [0]
            replacements[prettify(precondition)] = ('precondition',outcome,direction,resource,free_var)
            rules[outcome]['preconditions']['compare'].append( (direction,resource,free_var))
            free_variables.append(['condition',free_var,resource])
        elif 'overlaps' == terms[0]['predicate'] or 'collide' == terms[0]['predicate']:
            if len(terms[0]['terms']) > 1:
                entity1  = prettify(terms[0]['terms'][0])
                entity2   = prettify(terms[0]['terms'][1])
                valence = False
                if  'collide' == terms[0]['predicate']:
                    valence = True
                elif prettify(terms[0]['terms'][2]) == 'true':
                    valence = True
                rules[outcome]['preconditions']['overlaps'].append( (entity1,entity2,valence))
        elif 'timer_elapsed' == terms[0]['predicate']:
            rules[outcome]['preconditions']['timer_elapsed'].append(timers[prettify(terms[0]['terms'][0])])
        else:
            rules[outcome]['preconditions']['other'].append( prettify(terms[0]))
   
    free_action_variables = []
    for result in result['result']:

        
        result = result[0]
        terms = result['terms']
        outcome = prettify(terms[0])
        if 'modify' == terms[1]['predicate']:
            direction  = prettify(terms[1]['terms'][0])
            resource   = prettify(terms[1]['terms'][1])
            free_var = [1]
            replacements[prettify(result)] = ('result',outcome,direction,resource,free_var)
            rules[outcome]['results']['modify'].append( (direction,resource,free_var))
            free_variables.append(['action',free_var,resource])
        elif 'add' == terms[1]['predicate']:
            entity   = prettify(terms[1]['terms'][0])
            rules[outcome]['results']['add'].append( (entity))
        elif 'delete' == terms[1]['predicate']:
            entity   = prettify(terms[1]['terms'][0])
            rules[outcome]['results']['delete'].append( (entity))
            
        else:
            rules[outcome]['results']['other'].append(prettify(terms[1]))
    return settings,free_variables,rules,replacements

def run_once(rules,settings,player_model,depth):
    state = {}
    for setting in settings:
        if 'initialize' == setting[0]:
            state[setting[1]] = setting[2]
    next_state = {}
    history = []
    for timestep in range(depth):
        rules_fired = []
        
        for s,v in state.items():
            next_state[s] = v
        for outcome in rules:
            outcome_fails = random.random() > player_model[outcome]
            if outcome_fails:
                continue
            for condition in rules[outcome]['preconditions']['timer_elapsed']:
                if timestep % condition != 0:
                    outcome_fails = True
                else:
                    break
            
            for condition in rules[outcome]['preconditions']['compare']:
                if not comparators[condition[0]](state[condition[1]], condition[2]):
                    outcome_fails = True
                    break
            
            if outcome_fails:
                continue
            for condition in rules[outcome]['preconditions']['overlaps']:
                if condition[2] and state[condition[0]][0] <= 0 or state[condition[1]][0]  <= 0 or  state[condition[0]][0] + state[condition[1]][0]  <= 1:
                    outcome_fails = True
                    break
                if condition[2]:
                    val = state[condition[0]][0] + state[condition[1]][0]
                else:
                    val = 10- (state[condition[0]][0]+ state[condition[1]][0])
                outcome_fails =  outcome_fails or random.random() > 0.9/(1+np.exp(-0.75*(val-5)))
                
            if outcome_fails:
                continue

            rules_fired.append(outcome)
            for action in rules[outcome]['results']['modify']:
                next_state[action[1]] = [modifiers[action[0]](next_state[action[1]][0],action[2][0])]
            for action in rules[outcome]['results']['add']:
                next_state[action][0] += 1
            for action in rules[outcome]['results']['delete']:
                next_state[action][0] -= 1
                state[action][0] = max(0,state[action][0])
                
        history.append(rules_fired)
        for s,v in next_state.items():
            state[s] = v
    return history

def score_individual(free_variables,rules,settings,player_model,depth,simulation_count):
    
    def score(individual): 
        outcome_reached = set()  
        fitness = 0
        earliest_reached = {}
        latest_reached = {}
        seen = {}
        for simulations in range(simulation_count):     
            for free_var,set_var in zip(free_variables,individual):
                free_var[1][0] = set_var
            history =  run_once(rules,settings,player_model,depth)
            for step_ind,step in enumerate(history):
                for rule in step:
                    outcome_reached.add(rule)
                    if rule not in earliest_reached:
                        earliest_reached[rule] = float('inf')
                        latest_reached[rule] = float('-inf')
                    if rule not in seen:
                        seen[rule] = set()
                    seen[rule].add(step_ind)
                    earliest_reached[rule] = min(step_ind,earliest_reached[rule])
                    latest_reached[rule] = max(step_ind,latest_reached[rule])
        for outcome in rules:
            if outcome not in latest_reached:
                latest_reached[outcome] = depth*2
            if outcome not in earliest_reached:
                earliest_reached[outcome] = depth*2
            if outcome not in seen:
                seen[outcome] = set()
        outcome_weight = 1000
        fitness += outcome_weight*(len(outcome_reached)-len(rules))

        end_weight = 10

        for outcome in rules:
            has_mode_change = False
            for action in rules[outcome]['results']['other']:
                if 'mode_change' in action:
                    has_mode_change = True
                    break
            if has_mode_change:
                fitness += -end_weight*(depth-earliest_reached[outcome])
                fitness += end_weight*latest_reached[outcome]
                #print outcome, earliest_reached[outcome],latest_reached[outcome],fitness
            else:
                fitness += (depth - len(seen[rule])) * -1

        return (fitness,)
    return score
if __name__ == '__main__':

    args = sys.argv[1:]
    if '-s' in args:
        random.seed(int(args[args.index('-s')+1]))
        args = args[:args.index('-s')] + args[args.index('-s')+2:]
        print args
    out = solve_randomly(args)
    settings,free_variables,rules,replacements = parse_game(out)
    simulation_count = 50
    depth = 20
    display = False

    player_model_mappings = {'player_will_attempt':0.7,
                             'undetermined':0.5,
                             'must_happen':1,
                             'player_will_avoid':0.2,
                             'player_might_attempt':0.5}
    player_model = {}
    for o in ['player_model']:
       
        for oo in out[o]:        
            for ooo in oo:
                outcome =prettify(ooo['terms'][0])
                cond =prettify(ooo['terms'][1])
                player_model[outcome] = player_model_mappings[cond]
                
    creator.create("FitnessMax", base.Fitness, weights=(1.0,))
    creator.create("Individual", list, fitness=creator.FitnessMax)

    toolbox = base.Toolbox()
    def rand_range(min_,max_):
        def gen():
            return random.randrange(min_,max_)
        return gen


    #player_model = {rule:1 for rule in rules}
    
    toolbox.register("attr_int", rand_range(0,10))
    toolbox.register("individual", tools.initRepeat, creator.Individual,
                     toolbox.attr_int, n=len(free_variables))
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)

    toolbox.register("mate", tools.cxTwoPoint)
    toolbox.register("mutate", tools.mutGaussian, mu=2, sigma=4, indpb=0.1)
    toolbox.register("select", tools.selTournament, tournsize=3)
    toolbox.register("evaluate", score_individual(free_variables,rules,settings,player_model,depth,simulation_count))
    add = set([])
    for action in out['action']:
        if action[0]['terms'][0]['predicate'] == 'add':
            add.add(prettify(action[0]['terms'][0]['terms'][0]))
            
    many = set([])
    for oo in out['many']:
        for ooo in oo:
            ooo = prettify(ooo['terms'][0])
            if ooo not in add:
                many.add( ooo)
    def checkBounds(min, max):
        def decorator(func):
            def wrapper(*args, **kargs):
                offspring = func(*args, **kargs)
                for child in offspring:
                    for i in xrange(len(child)):
                        child[i] = np.round(child[i])
                        if child[i] > max:
                            child[i] = max
                        elif child[i] < min:
                            child[i] = min
                            
                        if free_variables[i][0] == 'initialize' and free_variables[i][2] in many and child[i] < 2:
                            child[i] = 2
                            
                return offspring
            return wrapper
        return decorator
    toolbox.decorate("individual", checkBounds(0.1, 10))
    toolbox.decorate("mate", checkBounds(0.1, 10))
    toolbox.decorate("mutate", checkBounds(0.1, 10))
    pop = toolbox.population(n=20)
    CXPB, MUTPB, NGEN = 0.5, 0.2, 40
  
    
    # Evaluate the entire population
    fitnesses = map(toolbox.evaluate, pop)
    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    for g in range(NGEN):
        # Select the next generation individuals
        offspring = toolbox.select(pop, len(pop))
        # Clone the selected individuals
        offspring = toolbox.map(toolbox.clone, offspring)

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
        fitnesses = toolbox.map(toolbox.evaluate, invalid_ind)
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
    print '======================================'
    
    for free_var,set_var in zip(free_variables,best_ind):
        free_var[1][0] = set_var

    #Have to do find and replaces in this order since outcome and timer might include entity and resource names
    find_and_replace = []
    for o in ['outcome','timer','entity','resource']:
        for oo in out[o]:
            for ooo in oo:
                if 'terms' in ooo['terms'][0]:
                    find = prettify(ooo['terms'][0]['terms'][0])
                    replace = replace = find.replace('(','_').replace(',','_X_').replace(')','_XX_')
                    find = '{}({})'.format(o,find)
                    replace = '{}({})'.format(o,replace)
                    print find,replace
                    find_and_replace.append((find,replace))
    
    out_string = []
    for o in ['entity','resource','singular','many','overlapLogic','initialize', 'goal','controlLogic','timer_logic']:
        for oo in out[o]:
            for ooo in oo:
                prettified = prettify(ooo).split('(')[0]
                if 'entity' in prettified or 'resource' in prettified:
                    out_string.append( prettify(ooo['terms'][0])+'.')
                else:
                    out_string.append( prettify(ooo)+'.')
        if len(out[o]) > 0:
            out_string.append( '')
    outcome2precond = {}
    replace_precondition = {}
    for setting in settings:
        if setting[0] == 'initialize':
            if setting[3] == 'set':
                out_string.append( 'initialize(set_value({},scalar({}))).'.format(setting[1],int(setting[2][0])))
                   
    out_string.append( '')
    
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
        every_frames.add(prettify(every_frame['terms'][0]))
        
    replace = {}    
    for result in out['replace']:
        outcome = prettify(result[0]['terms'][0])

        replace[outcome] = prettify(result[0]['terms'][1])
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


    sorted2outcome = {}
    for outcome in sorted(outcome2precond):
        for precond in outcome2precond[outcome]:
            sorted2outcome[prettify(precond['terms'][-1])] = outcome
    
    for outcome in sorted(sorted2outcome):
        outcome = sorted2outcome[outcome]
        if outcome not in collidesOutcome:
            for precond in outcome2precond[outcome]:
                if prettify(precond) in replacements:
                    repl = replacements[prettify(precond)]
                    #('precondition',outcome,direction,resource,free_var)
                    out_string.append( 'precondition({}({},scalar({})),{}).'.format(repl[2],repl[3],int(floor((repl[4][0]))),repl[1]))
                else:
                    out_string.append( prettify(precond)+'.')
            if outcome in outcome2result:
                for result in outcome2result[outcome]:
                    if prettify(result) in replacements:
                        repl = replacements[prettify(result)]
                        action = repl[2]
                        if repl[1] in every_frames:
                            
                            action += '_over_time'
                        out_string.append( 'result({},{}({},scalar({}))).'.format(repl[1],action,repl[3],int(ceil((repl[4][0])))))
                    else:
                        out_string.append( replace.get(prettify(result),prettify(result))+'.')
            out_string.append( '')
    for outcome in collidesOutcome:
        for precond in outcome2precond[outcome]:
            out_string.append( prettify(precond)+'.')
        if outcome in outcome2result:
            for result in outcome2result[outcome]:
                if prettify(result) in replacements:
                    repl = replacements[prettify(result)]
                    action = repl[2]
                    if repl[1] in every_frames:
                            
                        action += '_over_time'
                    out_string.append( 'result({},{}({},scalar({}))).'.format(repl[1],action,repl[3],int(ceil((repl[4][0])))))
                else:
                    out_string.append( replace.get(prettify(result),prettify(result))+'.')
        out_string.append( '')
    

    for o in ['reading']:
        for oo in out[o]:
            for ooo in oo:
                out_string.append( prettify(ooo)+'.')
        if len(out[o]) > 0:
            out_string.append( '')
    out_string  = '\n'.join(out_string)
    
    for f,r in find_and_replace:
        out_string = out_string.replace(f,r)
    print out_string

    print '======================================'
    labels = {}
    for o in ['label']:
        for oo in out[o]:
            for label in oo:
                labels[prettify(label['terms'][0])] = prettify(label['terms'][1])

    for o in ['reading']:
        for oo in out[o]:
            for ooo in oo:
                reading = prettify(ooo)
                if 'goal' in reading:
                    print "The goal is to " + prettify(ooo['terms'][0]['terms'][0]) + " " + labels[prettify(ooo['terms'][1]['terms'][0])]


    will_dos = []
    avoids = []
    for o in ['player_model']:
       
        for oo in out[o]:        
            for ooo in oo:
                outcome =hashable(ooo['terms'][0])
                cond =prettify(ooo['terms'][1])
                if cond == 'player_will_attempt':
                    will_dos.append(outcome)
                if cond == 'player_will_avoid':
                    avoids.append(outcome)
    press_mapping = {'pressed':'pressing',
                     'held':'holding'}
    key_mapping = {'mouse':'mouse button',
                   'space':'space bar',
                   'up_arrow':'up key',
                   'down_arrow':'down key',
                   'left_arrow':'left key',
                   'right_arrow':'right key'}
    if will_dos:
        print '\nThey will do this by'

        for outcome_ind,outcome in enumerate(will_dos):
            for ind,precond in enumerate(outcome2precond[outcome]):
                precond = precond['terms'][0]
                if 'overlaps' == precond['predicate']:
                    if 'true' == precond['terms'][2]['predicate']:
                        print '\tattempting to make a ' + labels[prettify(precond['terms'][1]['terms'][0])] + ' and ' + labels[prettify(precond['terms'][0]['terms'][0])] + ' touch'
                    else:
                        print '\tattempting to keep a ' + labels[prettify(precond['terms'][1]['terms'][0])] + ' and ' + labels[prettify(precond['terms'][0]['terms'][0])] + ' from touching'
                elif 'control_event' == precond['predicate']:
                    if 'click' ==  precond['terms'][0]['predicate']:
                        print '\tclicking on a ' + labels[prettify(precond['terms'][0]['terms'][0]['terms'][0])]
                    elif 'button' == precond['terms'][0]['predicate']:
                        verb = precond['terms'][0]['terms'][1]['predicate']
                        button = precond['terms'][0]['terms'][0]['predicate']
                        print '\t {} the {}'.format(press_mapping[verb],key_mapping[button])
                else:
                    print prettify(precond)
                if len(outcome2precond[outcome]) > 1:
                    if ind == 0:
                        print '\t at the same time as'
                    elif ind < len(outcome2precond[outcome])-1:
                        print '\t and'
            if outcome_ind < len(will_dos)-1:
                print '\n\tor\n'

  
                
    if avoids:
        print '\nThey will avoid'

        for outcome_ind,outcome in enumerate(avoids):
            for ind,precond in enumerate(outcome2precond[outcome]):
                precond = precond['terms'][0]
                if 'overlaps' == precond['predicate']:
                    if 'true' == precond['terms'][2]['predicate']:
                        print '\tattempting to make a ' + labels[prettify(precond['terms'][1]['terms'][0])] + ' and ' + labels[prettify(precond['terms'][0]['terms'][0])] + ' touch'
                    else:
                        print '\tattempting to keep a ' + labels[prettify(precond['terms'][1]['terms'][0])] + ' and ' + labels[prettify(precond['terms'][0]['terms'][0])] + ' from touching'
                elif 'control_event' == precond['predicate']:
                    if 'click' ==  precond['terms'][0]['predicate']:
                        print '\tclicking on a ' + labels[prettify(precond['terms'][0]['terms'][0]['terms'][0])]
                    elif 'button' == precond['terms'][0]['predicate']:
                        verb = precond['terms'][0]['terms'][1]['predicate']
                        button = precond['terms'][0]['terms'][0]['predicate']
                        print '\t{} the {}'.format(press_mapping[verb],key_mapping[button])
                else:
                    print prettify(precond)
                if len(outcome2precond[outcome]) > 1:
                    if ind == 0:
                        print '\t at the same time as'
                    elif ind < len(outcome2precond[outcome])-1:
                        print '\t and'
            if outcome_ind < len(will_dos)-1:
                print '\n\tor\n'


    print '\nThe player controls the game by'
    for oo in out['controlLogic']:
        print ''
        for ooo in oo:
            ooo = ooo['terms'][0]
            if 'draggable' == ooo['predicate']:
                entity = ooo['terms'][0]['terms'][0]
                print '\tclicking-and-dragging {}s'.format(labels[prettify(entity)])
            else:
                print prettify(ooo)

    direction_mapping = {'towards':'towards',
                         'away':'away from'}
    for oo in out['action']:
        for ooo in oo:
            pretty = prettify(ooo)
            ooo = ooo['terms'][0]
            if 'move' in pretty and 'cursor' in pretty:
                print '\tthe {} moves {} the cursor'.format(labels[prettify(ooo['terms'][0]['terms'][0])],direction_mapping[prettify(ooo['terms'][1]['terms'][0])])
     
    for oo in out['condition']:
        for ooo in oo:
            pretty = prettify(ooo)
            precond = ooo['terms'][0]
            if 'control_event' in pretty:
                if 'click' ==  precond['terms'][0]['predicate']:
                    print '\tclicking on a ' + labels[prettify(precond['terms'][0]['terms'][0]['terms'][0])]
                elif 'button' == precond['terms'][0]['predicate']:
                    verb = precond['terms'][0]['terms'][1]['predicate']
                    button = precond['terms'][0]['terms'][0]['predicate']
                    print '\t{} the {}'.format(press_mapping[verb],key_mapping[button])

    sprites = {}
    for oo in out['initialize']:
        for ooo in oo:
            pretty = prettify(ooo)
            if 'set_sprite' in pretty or 'set_color' in pretty:
                ooo = ooo['terms'][0]
                entity = prettify(ooo['terms'][0]['terms'][0])
                if entity not in sprites:
                    sprites[entity] = {}
                if 'set_sprite' in pretty:
                    sprites[entity]['sprite'] = prettify(ooo['terms'][1])
                if 'set_color' in pretty:
                    sprites[entity]['color'] = prettify(ooo['terms'][1])
    print ''
    
    for sprite in sorted(sprites):
        print 'A ' +  labels[sprite] + ' looks like a ' + sprites[sprite]['color'] + ' ' + sprites[sprite]['sprite']
