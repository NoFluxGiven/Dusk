import os

dir_path = os.path.dirname(os.path.realpath(__file__))

with open( dir_path + '/npc_heroes.txt') as f:
    heroes = f.readlines()

capture = True
ignore_next_close = False
last_line = ''
nest_level = 0
facets_level = -1

new_heroes = []

for line in heroes:
    # enter
    if 'Facets' in line:
        # stop capturing
        capture = False
        new_heroes.append('        "Facets" {}\n\n')
    
    if '{' in line:
        if 'Facets' in last_line:
            facets_level = nest_level
        nest_level += 1

    if '}' in line:
        nest_level -= 1
        if nest_level == facets_level:
            capture = True
            facets_level = -1
            continue
    
    if capture:
        new_heroes.append( line )

    last_line = line

with open(dir_path + '/npc_heroes_facets_removed.txt', 'w+') as f:

    f.writelines( new_heroes )