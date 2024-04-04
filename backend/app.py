from flask import Flask, jsonify
import sqlite3
import os

app = Flask(__name__)
app.debug = True

@app.route('/testing', methods=['GET'])
def testing():
    returnAnswer = "Things are working"
    print(returnAnswer)
    return jsonify({}), 200

def get_db():
    db_path = os.path.join(os.path.dirname(__file__), 'database.db')
    db = sqlite3.connect(db_path)
    return db

@app.route('/getTutors', methods=['GET'])
def getTutors():
    db = get_db()
    query = db.execute("select * from users")
    everything = query.fetchall()
    return jsonify(everything), 200

if __name__ == '__main__':
    app.run()
