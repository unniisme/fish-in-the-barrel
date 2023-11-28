from flask import Flask, request
import json
from database_handler import Database
from datetime import datetime

def Info(message : str):
    print(f"[INFO][{datetime.now()}] {message}")

def Error(message : str):
    print(f"[ERROR][{datetime.now()}] {message}")

app = Flask(__name__)
db = Database()

Info("starting server")

@app.route('/save', methods=["POST"])
def save_data():
    try:
        data = request.data.decode()
        
        datadict = json.loads(data)

        tablename = datadict["table"]
        tabledata = datadict["data"]

        Info(f"Update to {tablename}")

        try:
            db.AppendToTable(tablename, tabledata)  
        except KeyError:
            db.CreateTable(tablename)
            db.AppendToTable(tablename, tabledata)  

        return "Success", 200
    except Exception as e:
        Error(e)
        return 500


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
