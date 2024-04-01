from flask import Flask, jsonify
import sqlite3


app = Flask(__name__)

def get_db():
    db = sqlite3.connect('database.db')
    return db

# gets all tutors regardless of course or whether or not they are online
@app.route('/getTutors', methods=['GET'])
def getTutors():
    db = get_db()
    query = db.execute("select * from users")
    everything = query.fetchall()
    return jsonify(everything), 200