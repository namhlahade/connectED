from flask import Flask, jsonify
import sqlite3
import os

app = Flask(__name__)

@app.route('/testing', methods=['GET'])
def testing():
    returnAnswer = "Things are working"
    return jsonify(returnAnswer), 200

# Function to get the database connection
def get_db():
    # Construct the absolute path for the database file
    db_path = os.path.join(os.path.dirname(__file__), 'database.db')
    db = sqlite3.connect(db_path)
    return db

# Endpoint to get all tutors
@app.route('/getTutors', methods=['GET'])
def getTutors():
    db = get_db()
    query = db.execute("select * from users")
    everything = query.fetchall()
    return jsonify(everything), 200