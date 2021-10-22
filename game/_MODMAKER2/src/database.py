from tinydb import TinyDB, Query

class Database():
    def __init__(self):
        self.db = TinyDB('../test/testdata.json')