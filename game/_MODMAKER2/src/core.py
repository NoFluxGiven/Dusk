from kvparser import *
import fileops as Files
from database import Database
import json

abilities = Files.LoadFileString("../scripts/npc/npc_abilities_custom.txt")
abilitiesDict = Parse(abilities)

tooltips = Files.LoadFileString("../resource/addon_english.txt")
tooltipsDict = Parse(tooltips)

with open('../test/abilities.json', 'w+') as f:
    json.dump(abilitiesDict, f)

with open('../test/tooltips.json', 'w+') as f:
    json.dump(tooltipsDict, f)

db = Database()
