from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL').replace("://", "ql://", 1)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class User(db.Model):
    uid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.Text, nullable=False)
    email = db.Column(db.Text, unique=True, nullable=False)
    bio = db.Column(db.Text)
    rating = db.Column(db.Float)
    isOnline = db.Column(db.Boolean)
    image = db.Column(db.Text)

class Class(db.Model):
    cid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    className = db.Column(db.Text, unique=True, nullable=False)

class Review(db.Model):
    uid = db.Column(db.Integer, db.ForeignKey('user.uid'), primary_key=True)
    review = db.Column(db.Text, primary_key=True)

class TutorClass(db.Model):
    uid = db.Column(db.Integer, db.ForeignKey('user.uid'), primary_key=True)
    cid = db.Column(db.Integer, db.ForeignKey('class.cid'), primary_key=True)
    price = db.Column(db.Float, nullable=False)


@app.before_first_request
def create_tables():
    db.create_all()

@app.route('/testing', methods=['GET'])
def testing():
    returnAnswer = "Things are working"
    return jsonify({"message": returnAnswer}), 200

@app.route('/getTutors', methods=['GET'])
def getTutors():
    tutors = User.query.all()
    # Format and return the query results...
    return jsonify(tutors), 200

if __name__ == '__main__':
    app.run()