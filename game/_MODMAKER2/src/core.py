from kvparser import *
import fileops as Files
from database import Database
import json

str = Files.LoadFileString("../../scripts/npc/npc_abilities_custom.txt")
data = Parse(str)

with open('../test/testdata.json', 'w') as f:
    json.dump(data, f)

db = Database()
