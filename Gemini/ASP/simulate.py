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
import multiprocessing
from typing import Dict, List

comparators = {'ge': lambda x, y: x > y,
               'le': lambda x, y: x < y,
               'eq': lambda x, y: x == y}
modifiers = {'increase': lambda x, y:  x + y,
             'decrease': lambda x, y:  x - y}


def solve(args, num_to_gen):
    """Run clingo with the provided argument list and return the parsed JSON result."""

    print_args = ['clingo'] + list(args) + [' | tr [:space:] \\\\n | sort ']
    args = ['clingo', '--outf=2'] + args
    print(' '.join(print_args))
    with subprocess.Popen(
        ' '.join(args),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True
    ) as clingo:
        outb, err = clingo.communicate()
        print('CLINGO DONE')
    if err:
        print(err)
    out = outb.decode("utf-8")
    with open('dump.lp', 'w') as outfile:
        result = json.loads(out)
        witness = result['Call'][0]['Witnesses'][-1]['Value']
        for atom in sorted(witness):
            outfile.write(atom + '\n')

    return parse_json_result(out, num_to_gen)


def solve_randomly(args, num_to_generate):
    """Like solve() but uses a random sign heuristic with a random seed."""
    return solve(args, num_to_generate)


def parse_terms(arguments):
    terms = []
    while len(arguments) > 0:
        l_paren = arguments.find('(')
        r_paren = arguments.find(')')
        comma = arguments.find(',')
        if l_paren < 0:
            l_paren = len(arguments) - 1
        if r_paren < 0:
            r_paren = len(arguments) - 1
        if comma < 0:
            comma = len(arguments) - 1
        next = min(l_paren, r_paren, comma)
        next_c = arguments[next]
        if next_c == '(':

            pred = arguments[:next]
            sub_terms, arguments = parse_terms(arguments[next + 1:])
            terms.append({'predicate': pred, 'terms': sub_terms})
        elif next_c == ')':
            pred = arguments[:next]
            if pred != '':
                terms.append({'predicate': arguments[:next]})
            arguments = arguments[next + 1:]
            return terms, arguments
        elif next_c == ',':
            pred = arguments[:next]
            if pred != '':
                terms.append({'predicate': arguments[:next]})
            arguments = arguments[next + 1:]
        else:
            terms.append({'predicate': arguments})
            arguments = ''
    return terms, ''


def parse_json_result(out, num_to_gen):
    """Parse the provided JSON text and extract a dict
    representing the predicates described in the first solver result."""
    result = json.loads(out)
    assert len(result['Call']) > 0
    assert len(result['Call'][0]['Witnesses']) > 0
    all_preds = []
    ids = list(range(len(result['Call'][0]['Witnesses'])))
    random.shuffle(ids)
    print('JSON LOADED', len(ids))
    for id in ids[:num_to_gen]:
        witness = result['Call'][0]['Witnesses'][id]['Value']

        class identitydefaultdict(collections.defaultdict):
            def __missing__(self, key):
                return key

        preds = collections.defaultdict(list)
        env = identitydefaultdict()

        for atom in witness:
            parsed, dummy = parse_terms(atom)
            preds[parsed[0]['predicate']].append(parsed)
        all_preds.append(preds)
    return all_preds


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
        items = frozenset((k, hashable(v)) for k, v in obj.items())
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
        name = prettify(timer[0]['terms'][0]['terms'][0])
        time = int(prettify(timer[0]['terms'][1]['terms'][0]))
        print('timer', name)
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
        if 'set_value' == terms['predicate']:
            settings.append(('initialize', prettify(terms['terms'][0]), [int(terms['terms'][1]['terms'][0]['predicate'])], 'set'))
        if 'add' in terms['predicate']:
            if prettify(terms['terms'][0]) not in adds:
                adds[prettify(terms['terms'][0])] = 0
            adds[prettify(terms['terms'][0])] += int(terms['terms'][1]['terms'][0]['predicate'])
    for add in adds:
        settings.append(('initialize', add, [adds[add]], 'add', ''))
    free_variables = []
    free_variable_count = {}
    for resource in resources:
        if resource not in initializations:
            free_var = [0]
            free_variable_count['none'] = len(free_variables)
            free_variables.append(['initialize', free_var, resource])
            settings.append(('initialize', resource, free_var, 'set'))

    for entity in entities:
        if entity not in initializations:
            free_var = [0]

            free_variable_count['none'] = len(free_variables)
            free_variables.append(['initialize', free_var, entity])
            settings.append(('initialize', entity, free_var, 'add'))

    rules = {}
    replacements = {}
    outcome_to_preconditions = {}
    for precondition in result['precondition']:
        precondition = precondition[0]
        terms = precondition['terms']
        outcome = prettify(terms[1])
        if outcome not in outcome_to_preconditions:
            outcome_to_preconditions[outcome] = []
        outcome_to_preconditions[outcome].append(precondition)

    ignore_press = []
    for outcome in outcome_to_preconditions:
        has_click = False
        has_press = False

        for precondition in outcome_to_preconditions[outcome]:
            if precondition['terms'][0]['predicate'] == 'control_event':
                if precondition['terms'][0]['terms'][0]['predicate'] == 'button':
                    has_press = True
                if precondition['terms'][0]['terms'][0]['predicate'] == 'click':
                    has_click = True
        if has_click and has_press:

            for precondition in outcome_to_preconditions[outcome]:
                if precondition['terms'][0]['predicate'] == 'control_event':
                    if precondition['terms'][0]['terms'][0]['predicate'] == 'button':
                        ignore_press.append(prettify(precondition))

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
        prettified = prettify(terms[0])

        if 'compare' == terms[0]['predicate']:
            direction = prettify(terms[0]['terms'][0])
            resource = prettify(terms[0]['terms'][1])
            if 'amount' not in prettified and 'distance' not in prettified:
                free_var = [0]
                replacements[prettify(precondition)] = ('precondition', outcome, direction, resource, free_var)
                rules[outcome]['preconditions']['compare'].append((direction, resource, free_var))
                free_variable_count[prettify(precondition)] = len(free_variables)
                free_variables.append(['condition', free_var, resource])
            elif 'distance' in prettified:
                entity1 = prettify(terms[0]['terms'][1]['terms'][0])
                entity2 = prettify(terms[0]['terms'][1]['terms'][1])
                valence = False
                rules[outcome]['preconditions']['overlaps'].append((entity1, entity2, True))

        elif 'overlaps' == terms[0]['predicate'] or 'collide' == terms[0]['predicate']:
            if len(terms[0]['terms']) > 1:
                entity1 = prettify(terms[0]['terms'][0])
                entity2 = prettify(terms[0]['terms'][1])
                valence = False
                if 'collide' == terms[0]['predicate']:
                    valence = True
                elif prettify(terms[0]['terms'][2]) == 'true':
                    valence = True
                rules[outcome]['preconditions']['overlaps'].append((entity1, entity2, valence))
        elif 'timer_elapsed' == terms[0]['predicate']:
            rules[outcome]['preconditions']['timer_elapsed'].append(timers[prettify(terms[0]['terms'][0])])
        else:
            rules[outcome]['preconditions']['other'].append(prettify(terms[0]))

    free_action_variables = []
    for result in result['result']:

        result = result[0]
        terms = result['terms']
        outcome = prettify(terms[0])
        if 'modify' == terms[1]['predicate'] and len(terms[1]['terms']) == 2:
            direction = prettify(terms[1]['terms'][0])
            resource = prettify(terms[1]['terms'][1])
            free_var = [1]
            replacements[prettify(result)] = ('result', outcome, direction, resource, free_var)
            free_variable_count[prettify(result)] = len(free_variables)
            rules[outcome]['results']['modify'].append((direction, resource, free_var))
            free_variables.append(['action', free_var, resource])
        elif 'add' == terms[1]['predicate']:
            entity = prettify(terms[1]['terms'][0])
            rules[outcome]['results']['add'].append((entity))
        elif 'delete' == terms[1]['predicate']:
            entity = prettify(terms[1]['terms'][0])
            rules[outcome]['results']['delete'].append((entity))

        else:
            rules[outcome]['results']['other'].append(prettify(terms[1]))
    return settings, free_variables, rules, replacements, free_variable_count, ignore_press


def run_once(rules, settings, player_model, depth):
    state = {}
    for setting in settings:
        if 'initialize' == setting[0]:
            state[setting[1]] = setting[2]
    next_state = {}
    history = []
    for timestep in range(depth):
        rules_fired = []

        for s, v in state.items():
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
                if condition[2] and state[condition[0]][0] <= 0 or state[condition[1]][0] <= 0 or state[condition[0]][0] + state[condition[1]][0] <= 1:
                    outcome_fails = True
                    break
                if condition[2]:
                    val = state[condition[0]][0] + state[condition[1]][0]
                else:
                    val = 10 - (state[condition[0]][0] + state[condition[1]][0])
                outcome_fails = outcome_fails or random.random() > 0.9 / (1 + np.exp(-0.75 * (val - 5)))

            if outcome_fails:
                continue

            rules_fired.append(outcome)
            for action in rules[outcome]['results']['modify']:
                if action[1] in next_state:
                    next_state[action[1]] = [modifiers[action[0]](next_state[action[1]][0], action[2][0])]
            for action in rules[outcome]['results']['add']:
                next_state[action][0] += 1
            for action in rules[outcome]['results']['delete']:
                next_state[action][0] -= 1
                state[action][0] = max(0, state[action][0])

        history.append((rules_fired, {s: v for s, v in next_state.items()}))
        for s, v in next_state.items():
            state[s] = v
    return history


def score(free_variables, rules, settings, player_model, depth, simulation_count, constraints, individual):
    outcome_reached = set()
    fitness = 0
    earliest_reached = {}
    latest_reached = {}
    seen = {}
    highest = {}
    constraint_violations = 0
    violation_cost = 2000
    for constraint in constraints:
        # print constraint[0],(individual[constraint[1]],individual[constraint[2]])
        print("IND " + str(individual))
        print("CMP " + str(comparators))
        print("Con " + str(constraint))
        if not comparators[constraint[0]](individual[constraint[1]], individual[constraint[2]]):
            constraint_violations -= violation_cost
    if constraint_violations <= -violation_cost:
        return (constraint_violations,)
    for simulations in range(simulation_count):

        for free_var, set_var in zip(free_variables, individual):
            free_var[1][0] = set_var
        history = run_once(rules, settings, player_model, depth)

        for step_ind, step in enumerate(history):
            for rule in step[0]:
                outcome_reached.add(rule)
                if rule not in earliest_reached:
                    earliest_reached[rule] = float('inf')
                    latest_reached[rule] = float('-inf')
                if rule not in seen:
                    seen[rule] = set()
                seen[rule].add(step_ind)
                earliest_reached[rule] = min(step_ind, earliest_reached[rule])
                latest_reached[rule] = max(step_ind, latest_reached[rule])
            for v in step[1]:
                if v not in highest:
                    highest[v] = -1
                if highest[v] < step[1][v][0]:
                    highest[v] = step[1][v][0]
    for outcome in rules:
        if outcome not in latest_reached:
            latest_reached[outcome] = depth * 2
        if outcome not in earliest_reached:
            earliest_reached[outcome] = depth * 2
        if outcome not in seen:
            seen[outcome] = set()
    outcome_weight = 1000
    fitness += outcome_weight * (len(outcome_reached) - len(rules))

    end_weight = 50

    for v in highest:
        if highest[v] > 10:
            fitness -= 1 * (highest[v] - 10)

    for outcome in rules:
        has_mode_change = False
        for action in rules[outcome]['results']['other']:
            if 'mode_change' in action:
                has_mode_change = True
                break
        if has_mode_change:
            fitness += -end_weight * (depth - earliest_reached[outcome])
            fitness += end_weight * latest_reached[outcome]
            # print outcome, earliest_reached[outcome],latest_reached[outcome],fitness
        else:
            fitness += (depth - len(seen[rule])) * -10

    return (fitness,)


if __name__ == '__main__':
    output_name = sys.argv[1]
    number_to_generate = int(sys.argv[2])
    args = sys.argv[3:]
    if '-s' in args:
        random.seed(int(args[args.index('-s') + 1]))
        args = args[:args.index('-s')] + args[args.index('-s') + 2:]
        print(args)
    outs = solve_randomly(args, number_to_generate)
    for output_ind, out in enumerate(outs[:]):

        for o in sorted(out):
            for t in out[o]:
                for tt in t:
                    print(prettify(tt))
        settings, free_variables, rules, replacements, free_variable_count, ignore_press = parse_game(out)
        print("GAME ", output_ind)
        simulation_count = 50
        depth = 10
        CXPB, MUTPB, NGEN, POP_COUNT = 0.5, 0.2, 50, 200
        display = False
        '''
        player_model_mappings = {'player_must_do':0.95,
                                 'player_will_attempt':0.7,
                                 'undetermined':0.5,
                                 'must_happen':1,
                                 'player_will_avoid':0.2,
                                 'player_might_attempt':0.5}
        '''
        player_model_mappings = {'player_must_do': 0.75,
                                 'player_will_attempt': 0.5,
                                 'undetermined': 0.2,
                                 'must_happen': 1,
                                 'player_will_avoid': 0.7,
                                 'player_might_attempt': 0.3}
        player_model = {}
        for o in ['player_model']:

            for oo in out[o]:
                for ooo in oo:
                    outcome = prettify(ooo['terms'][0])
                    cond = prettify(ooo['terms'][1])
                    player_model[outcome] = player_model_mappings[cond]

        creator.create("FitnessMax", base.Fitness, weights=(1.0,))
        creator.create("Individual", list, fitness=creator.FitnessMax)

        toolbox = base.Toolbox()
        nbCPU = multiprocessing.cpu_count()
        # chunk = len(pop) / nbCPU
        # print('workers=', nbCPU, 'chunksize=', chunk)
        # Leave a couple of cores free to be polite
        pool = multiprocessing.Pool(nbCPU-2)
        toolbox.register("map", pool.map)


        def rand_range(min_, max_):
            def gen():
                return random.randrange(min_, max_)
            return gen

        #player_model = {rule:1 for rule in rules}

        constraints = []
        for free_var in sorted(free_variable_count):
            print(free_var,)

        for constraint in out['constraint']:
            direction = prettify(constraint[0]['terms'][0])
            result1 = prettify(constraint[0]['terms'][1])
            result2 = prettify(constraint[0]['terms'][2])

            constraints.append((direction,
                                free_variable_count[result1],
                                free_variable_count[result2]))

        max_value = 10
        toolbox.register("attr_int", rand_range(0, max_value))
        toolbox.register("individual", tools.initRepeat, creator.Individual,
                         toolbox.attr_int, n=len(free_variables))
        toolbox.register("population", tools.initRepeat, list, toolbox.individual)

        toolbox.register("mate", tools.cxTwoPoint)
        toolbox.register("mutate", tools.mutGaussian, mu=5, sigma=7, indpb=0.1)
        #toolbox.register("mutate", tools.mutGaussian, mu=2, sigma=4, indpb=0.1)
        toolbox.register("select", tools.selTournament, tournsize=3)
        toolbox.register("evaluate", score, free_variables, rules, settings, player_model, depth, simulation_count, constraints)
        add = set([])
        for action in out['action']:
            if action[0]['terms'][0]['predicate'] == 'add':
                add.add(prettify(action[0]['terms'][0]['terms'][0]))

        many = set([])
        for oo in out['many']:
            for ooo in oo:
                ooo = prettify(ooo['terms'][0])
                if ooo not in add:
                    many.add(ooo)

        def checkBounds(min, max):
            def decorator(func):
                def wrapper(*args, **kargs):
                    offspring = func(*args, **kargs)
                    for child in offspring:
                        for i in range(len(child)):
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
        toolbox.decorate("individual", checkBounds(1.0, max_value))
        toolbox.decorate("mate", checkBounds(1.0, max_value))
        toolbox.decorate("mutate", checkBounds(1.0, max_value))
        pop = toolbox.population(n=POP_COUNT)

        # Evaluate the entire population
        fitnesses = toolbox.map(toolbox.evaluate, pop)
        for ind, fit in zip(pop, fitnesses):
            ind.fitness.values = fit

        for g in range(NGEN):
            # Select the next generation individuals
            offspring = toolbox.select(pop, len(pop))
            # Clone the selected individuals
            offspring = list(toolbox.map(toolbox.clone, offspring))

            if (len(free_variables) > 2):
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
        best = (float('-inf'),)
        best_ind = None
        for ind, fit in zip(pop, toolbox.map(toolbox.evaluate, pop)):
            if fit > best:
                best = fit
                best_ind = ind
        print(best)
        # print '=========='

        pool.terminate()

        good_vars = set([])
        bad_vars = set([])
        for o in ['reading']:
            for oo in out[o]:
                for ooo in oo:
                    if ooo['terms'][0]['predicate'] == 'good':
                        good_vars.add(prettify(ooo['terms'][1]))
                    if ooo['terms'][0]['predicate'] == 'bad':
                        bad_vars.add(prettify(ooo['terms'][1]))

        for free_var, set_var in zip(free_variables, best_ind):
            free_var[1][0] = set_var

        for o in ['project']:
            for oo in out[o]:
                for ooo in oo:
                    print(prettify(ooo))
        # Have to do find and replaces in this order since outcome and timer might include entity and resource names
        find_and_replace = [('compare(ge,', 'ge('),
                            ('compare(le,', 'le(')]
        for o in ['timer']:
            for oo in out[o]:
                for ooo in oo:
                    print('FIND', ooo['terms'][0])
                    if 'terms' in ooo['terms'][0]:
                        find = prettify(ooo['terms'][0])
                        replace = find.replace('(', '_').replace(',', '_X_').replace(')', '_XX_')

                        find_and_replace.append((find, replace))
        for o in ['outcome', 'entity', 'resource']:
            for oo in out[o]:
                for ooo in oo:
                    if 'terms' in ooo['terms'][0]:
                        find = prettify(ooo['terms'][0]['terms'][0])
                        replace = find.replace('(', '_').replace(',', '_X_').replace(')', '_XX_')
                        find = '{}({})'.format(o, find)
                        replace = '{}({})'.format(o, replace)
                        find_and_replace.append((find, replace))

        out_string = []
        for o in ['label', 'entity', 'resource', 'singular', 'many', 'overlapLogic', 'initialize', 'goal', 'controlLogic', 'timer_logic', 'pool', 'boundary']:
            for oo in out[o]:
                for ooo in oo:
                    prettified = prettify(ooo).split('(')[0]
                    if 'entity' in prettified or 'resource' in prettified:
                        out_string.append(prettify(ooo['terms'][0]) + '.')
                    else:
                        out_string.append(prettify(ooo) + '.')
            if len(out[o]) > 0:
                out_string.append('')
        outcome2precond = {}  # type: Dict[str, List[str]]
        replace_precondition = {}  # type: Dict[str, str]
        for setting in settings:
            if setting[0] == 'initialize':
                if setting[3] == 'set':
                    out_string.append('initialize(set_value({},scalar({}))).'.format(setting[1], int(setting[2][0])))

        out_string.append('')

        for precond in out['precondition']:
            if precond[0]['terms'][0]['predicate'] == 'overlaps' and len(precond[0]['terms'][0]['terms']) == 1:
                continue
            if prettify(precond[0]) in ignore_press:
                continue
            # XXXXXXXXX
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
            for ii, precond in enumerate(outcome2precond[outcome]):
                temp = prettify(precond)
                if 'collide' in temp:
                    collides = ii
                if 'overlaps' in temp:
                    overlaps = ii
            if collides != -1:
                outcome2precond[outcome].pop(overlaps)
                collidesOutcome.append(outcome)

        outcome2result = {}  # type: Dict[str, List[str]]
        every_frames = set()
        for every_frame in out['every_frame']:
            every_frame = every_frame[0]
            every_frames.add(prettify(every_frame['terms'][0]))

        replace = {}
        for result in out['replace']:
            outcome = prettify(result[0]['terms'][0])

            replace[outcome] = prettify(result[0]['terms'][1])
            # replace[outcome].append(result[0])

        for result in out['result']:
            outcome = hashable(result[0]['terms'][0])
            if outcome not in outcome2result:
                outcome2result[outcome] = []

            if result[0]['terms'][1]['predicate'] == 'increase' and result[0]['terms'][0]['predicate'] in every_frames:
                result[0]['terms'][1]['predicate'] = 'increase_over_time'
                # print ':',result[0]
                pass
            if result[0]['terms'][1]['predicate'] == 'decrease' and result[0]['terms'][0]['predicate'] in every_frames:
                result[0]['terms'][1]['predicate'] = 'decrease_over_time'
                pass
                # print ':',result[0]
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
                        # ('precondition',outcome,direction,resource,free_var)

                        print(repl[3], action, repl[4][0], repl[3] in good_vars, repl[3] in bad_vars)
                        if (repl[3] in good_vars and 'increase' in action) or (repl[3] in bad_vars and 'decrease' in action):
                            if repl[4][0] < 1:
                                repl[4][0] = 1
                            #repl[4][0] *= 4
                        if (repl[3] in good_vars and 'decrease' in action) or (repl[3] in bad_vars and 'increase' in action):
                            #repl[4][0] /= 4
                            if (repl[4][0] < 1):
                                repl[4][0] = 1
                            print('AFTERA', repl[3], action, repl[4][0])
                        out_string.append('precondition({}({},scalar({})),{}).'.format(repl[2], repl[3], int(floor((repl[4][0]))), repl[1]))
                    else:
                        out_string.append(prettify(precond) + '.')
                if outcome in outcome2result:
                    for result in outcome2result[outcome]:
                        if prettify(result) in replacements:
                            repl = replacements[prettify(result)]
                            action = repl[2]
                            if repl[1] in every_frames:

                                action += '_over_time'

                            print(repl[3], action, repl[4][0], repl[3] in good_vars, repl[3] in bad_vars)
                            if (repl[3] in good_vars and 'increase' in action) or (repl[3] in bad_vars and 'decrease' in action):
                                if repl[4][0] < 1:
                                    repl[4][0] = 1
                                repl[4][0] *= 4
                            if (repl[3] in good_vars and 'decrease' in action) or (repl[3] in bad_vars and 'increase' in action):
                                repl[4][0] /= 8
                                if (repl[4][0] < 1):
                                    repl[4][0] = 1
                            print('AFTERB', repl[3], action, repl[4][0])

                            out_string.append('result({},{}({},scalar({}))).'.format(repl[1], action, repl[3], int(ceil((repl[4][0])))))
                        elif result['terms'][1]['predicate'] == 'modify':
                            out_string.append('result({},{}({},{})).'.format(prettify(result['terms'][0]), prettify(result['terms'][1]['terms'][0]), prettify(result['terms'][1]['terms'][1]), prettify(result['terms'][1]['terms'][2])))
                        else:
                            out_string.append(replace.get(prettify(result), prettify(result)) + '.')
                out_string.append('')
        for outcome in collidesOutcome:
            for precond in outcome2precond[outcome]:
                out_string.append(prettify(precond) + '.')
            if outcome in outcome2result:
                for result in outcome2result[outcome]:
                    if prettify(result) in replacements:
                        repl = replacements[prettify(result)]
                        action = repl[2]
                        if repl[1] in every_frames:

                            action += '_over_time'
                            print(repl[3], action, repl[4][0], repl[3] in good_vars, repl[3] in bad_vars)
                            if (repl[3] in good_vars and 'increase' in action) or (repl[3] in bad_vars and 'decrease' in action):
                                if repl[4][0] < 1:
                                    repl[4][0] = 1
                                repl[4][0] *= 4
                            if (repl[3] in good_vars and 'decrease' in action) or (repl[3] in bad_vars and 'increase' in action):
                                repl[4][0] /= 4
                                if (repl[4][0] < 1):
                                    repl[4][0] = 1
                            print('AFTER', repl[3], action, repl[4][0])

                        out_string.append('result({},{}({},scalar({}))).'.format(repl[1], action, repl[3], int(ceil((repl[4][0])))))
                    else:
                        out_string.append(replace.get(prettify(result), prettify(result)) + '.')
            out_string.append('')

        for o in ['reading']:
            for oo in out[o]:
                for ooo in oo:
                    out_string.append(prettify(ooo) + '.')
            if len(out[o]) > 0:
                out_string.append('')
        out_str = '\n'.join(out_string)

        for f, r in find_and_replace:
            out_str = out_str.replace(f, r)
        out_str += '==========\n'
        sprites = {}  # type: Dict[str, Dict[str, str]]
        for oo in out['initialize']:
            for ooo in oo:
                pretty = prettify(ooo)
                if 'set_sprite' in pretty or 'set_color' in pretty:
                    ooo = ooo['terms'][0]
                    entity = prettify(ooo['terms'][0])
                    if entity not in sprites:
                        sprites[entity] = {}
                    if 'set_sprite' in pretty:
                        sprites[entity]['sprite'] = prettify(ooo['terms'][1])
                    if 'set_color' in pretty:
                        sprites[entity]['color'] = prettify(ooo['terms'][1])

        sprite_labels = {sprite: '[[{}|{}]]'.format(sprites[sprite]['color'], sprites[sprite]['sprite']) for sprite in sprites}

        labels = {}  # type: Dict[str, str]
        for o in ['label']:
            for oo in out[o]:
                for label in oo:
                    labels[prettify(label['terms'][0])] = prettify(label['terms'][1])

        for label in labels:
            if label not in sprite_labels:
                sprite_labels[label] = labels[label]

        colors = ['red', 'blue', 'green', 'orange', 'white', 'black', 'clear', 'amount(clear)']
        for c in colors:
            sprite_labels['{}'.format(c)] = '{}'.format(c)
        out_str += '<ul>\n'
        out_str += '<li>{}_{}.lp</li>\n'.format(output_name, output_ind + 1)

        out_str += '<li>GOAL:<ul>\n'.format(output_name, output_ind + 1)
        for o in ['reading']:
            for oo in out[o]:
                for ooo in oo:
                    reading = prettify(ooo)
                    print(reading)
                    if 'goal' in reading and 'amount' not in reading and 'distance' not in reading:
                        out_str += "<li>" + prettify(ooo['terms'][0]['terms'][0]).title() + " " + sprite_labels[prettify(ooo['terms'][1])] + '</li>\n'

        out_str += '</ul></li>\n'

        will_dos = []
        avoids = []
        for o in ['player_model']:

            for oo in out[o]:
                for ooo in oo:
                    print(prettify(ooo))
                    outcome = hashable(ooo['terms'][0])
                    cond = prettify(ooo['terms'][1])
                    if cond == 'player_will_attempt':
                        will_dos.append(outcome)
                    if cond == 'player_will_avoid':
                        avoids.append(outcome)
        press_mapping = {'pressed': 'pressing',
                         'held': 'holding'}
        key_mapping = {'mouse': 'mouse button',
                       'space': 'space bar',
                       'up_arrow': 'up key',
                       'down_arrow': 'down key',
                       'left_arrow': 'left key',
                       'right_arrow': 'right key'}

        def control_event_text(condition):
            out_str = ''
            if 'click' == condition['predicate']:
                out_str += 'clicking on a ' + sprite_labels[prettify(condition['terms'][0])] + '\n'
            elif 'button' == condition['predicate']:
                verb = condition['terms'][1]['predicate']
                button = condition['terms'][0]['predicate']
                out_str += '{} the {}'.format(press_mapping[verb], key_mapping[button]) + '\n'
            else:
                print(condition)
            return out_str

        if will_dos:
            out_str += '\n<li>SUBGOALS:<ul>\n'

            for outcome_ind, outcome in enumerate(will_dos):
                out_str += '<li>\n'
                for ind, precond in enumerate(outcome2precond[outcome]):
                    precond = precond['terms'][0]
                    if 'overlaps' == precond['predicate']:
                        if 'true' == precond['terms'][2]['predicate']:
                            out_str += 'attempting to make a ' + sprite_labels[prettify(precond['terms'][1])] + ' and ' + sprite_labels[prettify(precond['terms'][0])] + ' touch\n'
                        else:
                            out_str += '\tattempting to keep a ' + sprite_labels[prettify(precond['terms'][1])] + ' and ' + sprite_labels[prettify(precond['terms'][0])] + ' from touching\n'
                    elif 'control_event' == precond['predicate']:
                        out_str += '\t' + control_event_text(precond['terms'][0])
                    elif 'compare' == precond['predicate']:
                        if 'le' == precond['terms'][0]['predicate']:
                            out_str += 'having {} be low'.format(sprite_labels[prettify(precond['terms'][1])]) + '\n'
                        elif 'ge' == precond['terms'][0]['predicate']:
                            out_str += 'having {} be high'.format(sprite_labels[prettify(precond['terms'][1])]) + '\n'

                    else:
                        out_str += prettify(precond) + '\n'
                    if len(outcome2precond[outcome]) > 1:
                        if ind == 0:
                            out_str += '\t at the same time as\n'
                        elif ind < len(outcome2precond[outcome]) - 1:
                            out_str += '\t and\n'
                out_str += '</li>\n'
            out_str += '</ul></li>\n'

        if avoids:
            out_str += '<li>AVOID:<ul>\n'

            for outcome_ind, outcome in enumerate(avoids):
                out_str += '<li>\n'
                for ind, precond in enumerate(outcome2precond[outcome]):
                    precond = precond['terms'][0]
                    if 'overlaps' == precond['predicate']:
                        if 'true' == precond['terms'][2]['predicate']:
                            out_str += '\tattempting to make a ' + sprite_labels[prettify(precond['terms'][1])] + ' and ' + sprite_labels[prettify(precond['terms'][0])] + ' touch\n'
                        else:
                            out_str += '\tattempting to keep a ' + sprite_labels[prettify(precond['terms'][1])] + ' and ' + sprite_labels[prettify(precond['terms'][0])] + ' from touching\n'
                    elif 'control_event' == precond['predicate']:
                        if 'click' == precond['terms'][0]['predicate']:
                            out_str += '\tclicking on a ' + sprite_labels[prettify(precond['terms'][0]['terms'][0])] + '\n'
                        elif 'button' == precond['terms'][0]['predicate']:
                            verb = precond['terms'][0]['terms'][1]['predicate']
                            button = precond['terms'][0]['terms'][0]['predicate']
                            out_str += '\t{} the {}'.format(press_mapping[verb], key_mapping[button]) + '\n'
                    else:
                        out_str += prettify(precond) + '\n'
                    if len(outcome2precond[outcome]) > 1:
                        if ind == 0:
                            out_str += '\t at the same time as' + '\n'
                        elif ind < len(outcome2precond[outcome]) - 1:
                            out_str += '\t and\n'
                out_str += '</li>\n'
            out_str += '</ul>\n'

        out_str += '<li>CONTROLS:<ul>' + '\n'

        action_mapping = {'chases': 'chase',
                          'flees': 'flee',
                          'orbits': 'orbit',
                          'click_and_drag': 'clicking-and-dragging',
                          'pivots': 'rotate'}
        player_controls = {}

        for oo in out['player_controls_by']:
            for ooo in oo:
                player_controls[sprite_labels[prettify(ooo['terms'][0])]] = ooo['terms'][1]['terms'][0]

        for oo in out['entity_movement']:
            for ooo in oo:
                entity = sprite_labels[prettify(ooo['terms'][0])]
                movement_type = ooo['terms'][1]['predicate']
                action = ''
                if 'terms' in ooo['terms'][1]:
                    relative_to = prettify(ooo['terms'][1]['terms'][0])
                    if relative_to != 'cursor':
                        relative_to = sprite_labels[relative_to]

                    action = '{} the {}'.format(action_mapping[movement_type], relative_to)
                else:
                    action = action_mapping[movement_type]

                if entity in player_controls:
                    print('PLAYER CONTROLS', entity, player_controls[entity], control_event_text(player_controls[entity]))
                    out_str += '<li>\tcontrolling {} by making it {} \nby {}</li>\n'.format(entity, action, control_event_text(player_controls[entity]))
        # for oo in out['entity_movement']:
        #    for ooo in oo:
        #        pretty = prettify(ooo)
        #        ooo = ooo['terms'][0]
        #        if 'move' in pretty and 'cursor' in pretty:
        #            out_str += '<li>\tthe {} moves {} the cursor'.format(sprite_labels[prettify(ooo['terms'][0])],direction_mapping[prettify(ooo['terms'][1]['terms'][0])]) + '</li>'+ '\n'
        if False:
            for oo in out['condition']:
                for ooo in oo:
                    pretty = prettify(ooo)
                    precond = ooo['terms'][0]
                    if 'control_event' in pretty:
                        out_str += '<li>' + '\n'
                        if 'click' == precond['terms'][0]['predicate']:
                            out_str += '\tclicking on a ' + sprite_labels[prettify(precond['terms'][0]['terms'][0])] + '\n'
                        elif 'button' == precond['terms'][0]['predicate']:
                            verb = precond['terms'][0]['terms'][1]['predicate']
                            button = precond['terms'][0]['terms'][0]['predicate']
                            out_str += '\t{} the {}'.format(press_mapping[verb], key_mapping[button]) + '\n'
                        out_str += '</li>' + '\n'

        out_str += '</ul></ul>' + '\n'

        with open('{}_{}.lp'.format(output_name, output_ind + 1), 'w') as outfile:
            print('{}_{}.lp'.format(output_name, output_ind + 1))
            outfile.write(out_str)

        if len(outs) < number_to_generate:
            for ii in range(0, number_to_generate // len(outs)):
                print('duplicating ', output_ind, ' to ', output_ind + 1 + (ii + 1) * len(outs))
                with open('{}_{}.lp'.format(output_name, output_ind + 1 + (ii + 1) * len(outs)), 'w') as outfile:

                    outfile.write(out_str)

    exit(0)
