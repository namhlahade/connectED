from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from datetime import time
import os

app = Flask(__name__)

ENV = 'prod'

if ENV == 'dev':
    app.debug = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:dukegoogle2024@localhost/connectED'
else:
    app.debug = False
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://foslwlwkzycouo:165fcf956a947fbff3d6e0ab81a37104d223b45845a9702089143b7705f4122d@ec2-44-213-151-75.compute-1.amazonaws.com:5432/d6gpk6kq03j10h'

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
app.app_context().push()

class User(db.Model):
    __tablename__ = 'users'
    uid = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Text, nullable=False)
    email = db.Column(db.Text, unique=True, nullable=False)
    bio = db.Column(db.Text)
    rating = db.Column(db.Float)
    image = db.Column(db.Text)
    price = db.Column(db.Float, nullable=False)
    reviews_about_user = db.relationship('Review', backref='reviewed_user', lazy=True) # Look back at this
    tutor_classes = db.relationship('TutorClass', backref='tutor', lazy=True)


    def __init__(self, name, email, price, bio=None, rating=None, isOnline=False, image=None):
        self.name = name
        self.email = email
        self.price = price
        self.bio = bio
        self.rating = rating
        self.isOnline = isOnline
        self.image = image

class Review(db.Model):
    __tablename__ = 'reviews'
    rID = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer, db.ForeignKey('users.uid'))
    review = db.Column(db.Text)

    def __init__(self, uid, review):
        self.uid = uid
        self.review = review

class TutorClass(db.Model):
    __tablename__ = 'tutor_classes'
    uid = db.Column(db.Integer, db.ForeignKey('users.uid'), primary_key=True)
    cid = db.Column(db.Text, primary_key=True)

    def __init__(self, uid, cid, price):
        self.uid = uid
        self.cid = cid

class Availability(db.Model):
    __tablename__ = 'availabilities'
    id = db.Column(db.Integer, primary_key=True)
    tutor_uid = db.Column(db.Integer, db.ForeignKey('users.uid'), nullable=False)
    day_of_week = db.Column(db.Integer, nullable=False)  # 0 = Monday, 6 = Sunday
    start_time = db.Column(db.Time, nullable=False)
    end_time = db.Column(db.Time, nullable=False)

    tutor = db.relationship('User', backref='availabilities', lazy=True)

@app.route('/testing', methods=['GET'])
def testing():
    return jsonify({'message': 'API itself is working'}), 200

# Get all tutors -> Classes that the tutor teaches, availability, and profile information of tutor of tutor

@app.route("/getTutorAndClass", methods=['POST'])
def getTutorAndClass():
    try:
        tutors = User.query.all()
        tutors_data = []
        for tutor in tutors:
            tutor_info = {
                'uid': tutor.uid,
                'name': tutor.name,
                'email': tutor.email,
                'bio': tutor.bio,
                'rating': tutor.rating,
                'image': tutor.image,
                'price': tutor.price,
                'classes': [{'cid': tc.cid} for tc in tutor.tutor_classes]
            }
            tutors_data.append(tutor_info)

        return jsonify(tutors_data)
    except Exception as e:
        db.session.rollback()
        return str(e), 500

@app.route('/addTutor', methods=['POST'])
def addTutor():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')

    bio = None
    if 'bio' in data:
        bio = data.get('bio')

    rating = None
    if 'rating' in data:
        rating = data.get('rating')

    isOnline = True
    if 'isOnline' in data:
        isOnline = data.get('isOnline')

    image = None
    if 'image' in data:
        image = data.get('image')

    price = None
    if 'price' in data:
        price = data.get('price')

    existing_tutor = User.query.filter_by(email=email).first()
    if existing_tutor:
        return jsonify({"error": "Email already exists"}), 400

    tutor = User(name=name, email=email, bio=bio, rating=rating, isOnline=isOnline, image=image, price=price)
    db.session.add(tutor)
    db.session.commit()
    return jsonify({"message": "User added successfully"}), 201

@app.route('/getTutors', methods=['GET'])
def getTutors():
    users = User.query.all()
    users_data = []
    for user in users:
        user_data = {
            'uid': user.uid,
            'name': user.name,
            'email': user.email,
            'bio': user.bio,
            'rating': user.rating,
            'isOnline': user.isOnline,
            'image': user.image,
        }
        users_data.append(user_data)
    
    return {"users": users_data}

@app.route('/addTutorClass', methods=['POST'])
def addTutorClass():
    data = request.get_json()
    tutorId = data.get('tutorId')
    classId = data.get('classId')
    price = data.get('price')

    user = User.query.filter_by(uid=tutorId).first()
    class_ = Class.query.filter_by(cid=classId).first()

    if not user or not class_:
        return jsonify({'error': 'Tutor or Class not found'}), 404

    existing_tutor_class = TutorClass.query.filter_by(uid=tutorId, cid=classId).first()
    if existing_tutor_class:
        return jsonify({'error': 'Tutor class already exists'}), 400

    new_tutor_class = TutorClass(uid=tutorId, cid=classId, price=price)

    db.session.add(new_tutor_class)
    db.session.commit()

    return jsonify({'message': 'Tutor class added successfully'}), 201


@app.route('/getTutorClasses', methods=['POST'])
def getTutorClasses():
    data = request.get_json()
    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404
    tutor_classes = TutorClass.query.filter_by(uid=tutorId).all()
    class_ids = [tc.cid for tc in tutor_classes]
    classes = Class.query.filter(Class.cid.in_(class_ids)).all()
    class_names = [cls.className for cls in classes]

    return jsonify({'classes': class_names}), 200

@app.route('/deleteTutorClass', methods=['POST'])
def deleteTutorClass():
    data = request.get_json()
    tutorId = data.get('tutorId')
    classId = data.get('classId')

    if not tutorId or not classId:
        return jsonify({'error': 'Missing tutorId or classId'}), 400

    tutorClass = TutorClass.query.filter_by(uid=tutorId, cid=classId).first()
    if tutorClass:
        db.session.delete(tutorClass)
        db.session.commit()
        return jsonify({'message': 'Tutor class association deleted successfully'}), 200
    else:
        return jsonify({'error': 'Tutor class association not found'}), 404

@app.route('/addReview', methods=['POST'])
def addReview():
    data = request.get_json()
    reviewContent = data.get('reviewContent')
    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404

    newReview = Review(uid=tutorId, review=reviewContent)
    db.session.add(newReview)
    db.session.commit()

    return jsonify({'message': 'Review added successfully'}), 201

@app.route('/getReviews', methods=['POST'])
def getReviews():
    data = request.get_json()
    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404
    
    reviews = Review.query.filter_by(uid=tutorId).all()
    review_texts = [review.review for review in reviews]

    return jsonify({'reviews': review_texts}), 200

@app.route('/addAvailability', methods=['POST'])
def addAvailability():
    data = request.get_json()
    day_of_week = data.get('day_of_week')  # number from 0 (Monday) to 6 (Sunday)
    start_time = data.get('start_time')  # string in HH:MM format
    end_time = data.get('end_time')  # string in HH:MM format

    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404
    
    start_time_obj = time.fromisoformat(start_time)
    end_time_obj = time.fromisoformat(end_time)

    new_availability = Availability(tutor_uid=tutorId, day_of_week=day_of_week, start_time=start_time_obj, end_time=end_time_obj)
    db.session.add(new_availability)
    db.session.commit()

    return jsonify({'message': 'Availability added successfully'}), 201

@app.route('/deleteAvailability', methods=['POST'])
def deleteAvailability():
    data = request.get_json()
    availabilityId = data.get('availabilityId')

    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404

    availability = Availability.query.filter_by(tutor_uid=tutorId, id=availabilityId).first()
    if availability:
        db.session.delete(availability)
        db.session.commit()
        return jsonify({'message': 'Availability deleted successfully'}), 200
    else:
        return jsonify({'error': 'Availability not found'}), 404


@app.route('/viewAvailability', methods=['POST'])
def viewAvailability():
    data = request.get_json()
    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404

    availabilities = Availability.query.filter_by(tutor_uid=tutorId).all()

    availability_data = [{
        'day_of_week': availability.day_of_week,
        'start_time': availability.start_time.strftime('%H:%M'),
        'end_time': availability.end_time.strftime('%H:%M'),
        'availabilityId': availability.id
    } for availability in availabilities]

    return jsonify(availability_data), 200

# edit availability

if __name__ == '__main__':
    app.run()