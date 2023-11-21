from flask import Flask, request
import json
from database_handler import Database
from datetime import datetime

def Log(message : str):
    print(f"[INFO][{datetime.now()}] {message}")

app = Flask(__name__)
db = Database()

Log("starting server")

@app.route('/save', methods=["POST"])
def save_data():
    data = request.data.decode()
    
    datadict = json.loads(data)

    tablename = datadict["table"]
    tabledata = datadict["data"]

    Log(f"Update to {tablename}")

    try:
        db.AppendToTable(tablename, tabledata)  
    except KeyError:
        db.CreateTable(tablename)
        db.AppendToTable(tablename, tabledata)  

    return "Success"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
