from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

def create_app():
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL').replace("://", "ql://", 1)
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)
    
    with app.app_context():
        db.create_all()
    
    return app

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'user'
    uid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.Text, nullable=False)
    email = db.Column(db.Text, unique=True, nullable=False)
    bio = db.Column(db.Text)
    rating = db.Column(db.Float)
    isOnline = db.Column(db.Boolean)
    image = db.Column(db.Text)

class Class(db.Model):
    __tablename__ = 'class'
    cid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    className = db.Column(db.Text, unique=True, nullable=False)

class Review(db.Model):
    __tablename__ = 'review'
    uid = db.Column(db.Integer, db.ForeignKey('user.uid'), primary_key=True)
    review = db.Column(db.Text, primary_key=True)

class TutorClass(db.Model):
    __tablename__ = 'tutor_class'
    uid = db.Column(db.Integer, db.ForeignKey('user.uid'), primary_key=True)
    cid = db.Column(db.Integer, db.ForeignKey('class.cid'), primary_key=True)
    price = db.Column(db.Float, nullable=False)

app = create_app()

@app.route('/testing', methods=['GET'])
def testing():
    returnAnswer = "Things are working"
    return jsonify({"message": returnAnswer}), 200

@app.route('/getTutors', methods=['GET'])
def getTutors():
    tutors = User.query.all()
    # Ideally, format the tutors list into a serializable format before returning
    tutor_list = [{'uid': tutor.uid, 'name': tutor.name, 'email': tutor.email} for tutor in tutors]
    return jsonify(tutor_list), 200

if __name__ == '__main__':
    app.run()
