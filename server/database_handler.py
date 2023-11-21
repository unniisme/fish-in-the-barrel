import os
import json

class Database:

    def __init__(self, path = "data"):
        # Each table is a dictionary with string keys and any values
        self.tables = {}

        if not os.path.exists(path):
            os.makedirs(path, exist_ok=True)
        else:
            self.tables = {s.replace(".json", "") : f"{path}/{s}" for s in os.listdir(path) if ".json" in s}

        self.path = path

    def CreateTable(self, tablename : str):
        self.tables[tablename] = f"{self.path}/{tablename}.json"
        
        self._WriteTable(tablename, {})


    def GetTable(self, tablename : str, createOnNonExist : bool = False)->dict[str,any]:
        
        if tablename not in self.tables:
            if createOnNonExist:
                self.CreateTable(tablename)
            else:
                raise KeyError("Table does not exist")
        
        with open(self.tables[tablename]) as table:
            try:
                data = json.load(table)
            except json.decoder.JSONDecodeError:
                data = {} # Default to blank on error
        
        return data
    
    def _WriteTable(self, tablename : str, data : dict):
        with open(self.tables[tablename],  "w+") as table:
            json.dump(data, table, indent="\t")
    
    def AddToTable(self, tablename, key, value):

        data = self.GetTable(tablename)

        if key in data:
            raise KeyError("Entry already present in table")
        
        data[key] = value

        self._WriteTable(tablename, data)

    def AppendToTable(self, tablename, table : dict[str, any]):

        for key in table:
            print(key)
            try:
                self.ModifyTable(tablename, key, table[key])
            except KeyError:
                self.AddToTable(tablename, key, table[key])

    def ModifyTable(self, tablename, key, value):

        data = self.GetTable(tablename)
        
        if key not in data:
            raise KeyError("Entry not present in table")
        
        data[key] = value
        

        self._WriteTable(tablename, data)

    def DeleteFromTable(self, tablename, key):

        data = self.GetTable(tablename)
        
        if key not in data:
            raise KeyError("Entry not present in table")
        
        del data[key]

        self._WriteTable(tablename, data)