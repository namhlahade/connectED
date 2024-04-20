from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from datetime import time
from datetime import datetime
import os

app = Flask(__name__)

ENV = 'prod'

if ENV == 'dev':
    app.debug = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:dukegoogle2024@localhost/connectED'
else:
    app.debug = False
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://tkmpawmgvuqusg:1b6a67f4d733073006c660fce5e2ec38d25d1cc7ad3e445b7b989328e134a21e@ec2-52-200-147-27.compute-1.amazonaws.com:5432/dfhmlv2ei49ep5'

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
app.app_context().push()

class User(db.Model):
    __tablename__ = 'users'
    email = db.Column(db.Text, unique=True, nullable=False, primary_key=True)
    name = db.Column(db.Text, nullable=False)
    bio = db.Column(db.Text)
    image = db.Column(db.Text)
    price = db.Column(db.Float, nullable=False)

    #Relationships
    reviews = db.relationship('Review', backref='reviewed_user', lazy=True)
    tutor_classes = db.relationship('TutorClass', backref='tutor', lazy=True)
    availabilities = db.relationship('Availability', backref='tutor', lazy=True)
    meetings = db.relationship('Meetings', backref='user', lazy=True)
    favorites = db.relationship('Favorites', foreign_keys='[Favorites.user_email]', backref='user', lazy=True)
    favorites_reviewed = db.relationship('Favorites', foreign_keys='[Favorites.reviewer_email]', backref='reviewer', lazy=True)

class Review(db.Model):
    __tablename__ = 'reviews'
    rID = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.Text, db.ForeignKey('users.email'))
    clarity = db.Column(db.Integer)
    prep = db.Column(db.Integer)
    review = db.Column(db.Text)
    rating = db.Column(db.Integer)

class TutorClass(db.Model):
    __tablename__ = 'tutor_classes'
    email = db.Column(db.Text, db.ForeignKey('users.email'), primary_key=True)
    className = db.Column(db.Text, primary_key=True)

class Availability(db.Model):
    __tablename__ = 'availabilities'
    id = db.Column(db.Integer, primary_key=True)
    tutor_email = db.Column(db.Text, db.ForeignKey('users.email'), nullable=False)
    day_of_week = db.Column(db.Integer, nullable=False)  # 0 = Monday, 6 = Sunday
    start_time = db.Column(db.Time, nullable=False)
    end_time = db.Column(db.Time, nullable=False)

class Meetings(db.Model):
    __tablename__ = 'meetings'
    id = db.Column(db.Integer, primary_key=True)
    user_email = db.Column(db.Text, db.ForeignKey('users.email'), nullable=False)
    meeting_date = db.Column(db.Date, nullable=False)
    start_time = db.Column(db.Time, nullable=False)
    end_time = db.Column(db.Time, nullable=False)

class Favorites(db.Model):
    __tablename__ = 'favorites'
    id = db.Column(db.Integer, primary_key=True)
    user_email = db.Column(db.Text, db.ForeignKey('users.email'), nullable=False)
    reviewer_email = db.Column(db.Text, db.ForeignKey('users.email'), nullable=False)




@app.route('/testing', methods=['GET'])
def testing():
    return jsonify({'message': 'API itself is working'}), 200

@app.route('/addTutor', methods=['POST'])
def addTutor():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')

    bio = None
    if 'bio' in data:
        bio = data.get('bio')

    image = None
    if 'image' in data:
        image = data.get('image')

    price = None
    if 'price' in data:
        price = data.get('price')
    
    try:
        existing_tutor = User.query.filter_by(email=email).first()
        if existing_tutor:
            return jsonify({"error": "Email already exists"}), 400

        tutor = User(name=name, email=email, bio=bio, image=image, price=price)
        db.session.add(tutor)
        db.session.commit()
        return jsonify({"message": "User added successfully"}), 201
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500


@app.route('/getTutors', methods=['GET'])
def getTutors():
    try:
        users = User.query.all()
        tutor_data = []
        for user in users:

            availability_dict = availabilityHelper(user.email)
            reviews = get_reviews(user.email)
            favorites = get_favorites(user.email)

            user_data = {
                'email': user.email,
                'name': user.name,
                'bio': user.bio,
                'image': user.image,
                'price': user.price,
                'availabilities': availability_dict,
                'reviews': reviews,
                'favorites': favorites,
                'tutor_classes': [
                    tutor_class.className for tutor_class in user.tutor_classes
                ]
            }
            tutor_data.append(user_data)

        return jsonify({"tutors": tutor_data}), 200
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500

def get_reviews(tutor_email):
    reviews = Review.query.filter_by(email=tutor_email).all()
    return [
        {
            'clarity': review.clarity,
            'prep': review.prep,
            'review': review.review,
            'rating': review.rating
        } for review in reviews
    ]

def get_favorites(tutor_email):
    favorites = Favorites.query.filter_by(user_email = tutor_email).all()
    return [
            favorite.reviewer_email for favorite in favorites
            ]


@app.route('/getTutorReviews', methods=['POST'])
def getTutorReviews():
    data = request.get_json()
    tutor_email = data.get('tutorEmail')

    if not tutor_email:
        return jsonify({'error': 'Missing email parameter'}), 400

    try:
        reviews = Review.query.filter_by(email=tutor_email).all()
        review_data = [
            {
                'rating': review.rating,
                'clarity': review.clarity,
                'prep': review.prep,
                'review_text': review.review
            } for review in reviews
        ]
        return jsonify({"reviews": review_data})
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500
    

    
@app.route('/addAvailability', methods=['POST'])
def addAvailability():
    data = request.get_json()
    day_of_week = data.get('day_of_week')  # number from 0 (Monday) to 6 (Sunday)
    start_time = data.get('start_time')  # string in HH:MM format
    end_time = data.get('end_time')  # string in HH:MM format

    tutor_email = data.get('tutor_email')

    tutor = User.query.get(tutor_email)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404
    
    start_time_obj = time.fromisoformat(start_time)
    end_time_obj = time.fromisoformat(end_time)

    try:
        new_availability = Availability(tutor_email=tutor_email, day_of_week=day_of_week, start_time=start_time_obj, end_time=end_time_obj)
        db.session.add(new_availability)
        db.session.commit()

        return jsonify({'message': 'Availability added successfully'}), 201
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500

@app.route('/getFavorite', methods=['POST'])
def getFavorite():
    data = request.get_json()
    user_email = data.get('tutorEmail')

    if not user_email:
        return jsonify({'error': 'Missing email parameter'}), 400

    try:
        favorites = Favorites.query.filter_by(user_email=user_email).all()
        favorite_tutors = []
        for favorite in favorites:
            tutor = User.query.filter_by(email=favorite.reviewer_email).first()
            if tutor:
                availabilityDict = availabilityHelper(tutor.email)
                tutor_data = {
                    'email': tutor.email,
                    'name': tutor.name,
                    'bio': tutor.bio,
                    'image': tutor.image,
                    'price': tutor.price,
                    'availabilities': availabilityDict,
                    'tutor_classes': [
                        {
                            'class_name': tutor_class.className
                        } for tutor_class in tutor.tutor_classes
                    ]
                }
                favorite_tutors.append(tutor_data)
        return jsonify({"favorites": favorite_tutors})
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500
    
@app.route('/addFavorite', methods=['POST'])
def addFavorite():
    data = request.get_json()
    user_email = data.get('userEmail')
    tutor_email = data.get('tutorEmail')

    if not user_email or not tutor_email:
        return jsonify({'error': 'Missing userEmail or tutorEmail parameter'}), 400

    try:
        existing_favorite = Favorites.query.filter_by(user_email=user_email, reviewer_email=tutor_email).first()
        if existing_favorite:
            return jsonify({'message': 'This tutor is already a favorite of the user'}), 409

        new_favorite = Favorites(user_email=user_email, reviewer_email=tutor_email)
        db.session.add(new_favorite)
        db.session.commit()

        return jsonify({'message': 'Tutor added to favorites successfully'}), 201
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500

@app.route('/deleteFavorite', methods=['POST'])
def deleteFavorite():
    data = request.get_json()
    user_email = data.get('userEmail')
    tutor_email = data.get('tutorEmail')

    if not user_email or not tutor_email:
        return jsonify({'error': 'Missing userEmail or tutorEmail parameter'}), 400

    try:
        favorite = Favorites.query.filter_by(user_email=user_email, reviewer_email=tutor_email).first()
        if not favorite:
            return jsonify({'message': 'Favorite not found'}), 404

        db.session.delete(favorite)
        db.session.commit()

        return jsonify({'message': 'Favorite deleted successfully'}), 200
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500
    
@app.route('/addClass', methods=['POST'])
def addClass():
    try:
        data = request.get_json()
        tutor_email = data.get('tutorEmail')
        className = data.get('className')

        classRelationship = TutorClass(email=tutor_email, className=className)
        db.session.add(classRelationship)
        db.session.commit()

        return jsonify({"message": "Class added successfully"}), 201

    except Exception as e:
        db.session.rollback()
        return str(e), 500


@app.route('/getTutorInfo', methods=['POST'])
def getTutorInfo():
    try:
        data = request.get_json()
        tutor_email = data.get('tutorEmail')
        if not tutor_email:
            return jsonify({"error": "Missing tutorEmail parameter"}), 400

        tutor = User.query.filter_by(email=tutor_email).first()
        if not tutor:
            return jsonify({"error": "Tutor not found"}), 404

        availability_dict = availabilityHelper(tutor_email)
        reviews = get_reviews(tutor_email)
        favorites = get_favorites(tutor_email)

        tutor_data = {
            'email': tutor.email,
            'name': tutor.name,
            'bio': tutor.bio,
            'image': tutor.image,
            'price': tutor.price,
            'availabilities': availability_dict,
            'reviews': reviews,
            'favorites': favorites,
            'tutor_classes': [
                {
                    'class_name': tutor_class.className
                } for tutor_class in tutor.tutor_classes
            ]
        }

        return jsonify(tutor_data), 200

    except Exception as e:
        db.session.rollback()
        return str(e), 500


@app.route('/addTutorReview', methods=['POST'])
def addTutorReview():
    data = request.get_json()
    rating = data.get("rating")
    clarity = data.get("clarity")
    prep = data.get("prep")
    review_text = data.get("review")
    tutor_email = data.get("tutorEmail")

    if not all([rating, clarity, prep, review_text, tutor_email]):
        return jsonify({'error': 'Missing one or more required fields'}), 400

    try:
        tutor = User.query.filter_by(email=tutor_email).first()
        if not tutor:
            return jsonify({'error': 'Tutor not found'}), 404

        new_review = Review(
            email=tutor_email,
            clarity=clarity,
            prep=prep,
            review=review_text,
            rating=rating
        )

        db.session.add(new_review)
        db.session.commit()

        return jsonify({'message': 'Review added successfully'}), 201

    except Exception as e:
        db.session.rollback()
        return str(e), 500


@app.route('/addMeeting', methods=['POST'])
def addMeeting():
    data = request.get_json()
    user_email = data.get("userEmail")
    meeting_date = data.get("meetingDate")
    start_time = data.get("startTime")
    end_time = data.get("endTime")

    if not all([user_email, meeting_date, start_time, end_time]):
        return jsonify({'error': 'Missing required field(s)'}), 400

    try:
        meeting_date = datetime.strptime(meeting_date, "%Y-%m-%d").date()
        start_time = datetime.strptime(start_time, "%H:%M").time()
        end_time = datetime.strptime(end_time, "%H:%M").time()
    except ValueError:
        return jsonify({'error': 'Invalid date or time format. Use YYYY-MM-DD for dates and HH:MM for times.'}), 400

    try:
        new_meeting = Meetings(
            user_email=user_email,
            meeting_date=meeting_date,
            start_time=start_time,
            end_time=end_time
        )
        db.session.add(new_meeting)
        db.session.commit()

        return jsonify({'message': 'Meeting added successfully'}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

def time_range(start, end):
    return [(time(hour=x), time(hour=x+1)) for x in range(start.hour, end.hour)]

def availabilityHelper(tutor_email):
    if not tutor_email:
        return {'error': 'Missing tutorEmail parameter'}, 400  # This should probably be handled differently since this function is expected to return a dictionary, not a response object directly.

    # Initialize returnDict with day names to avoid conditional initialization issues.
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    returnDict = {day: [] for day in days}

    # Fetch the weekly availability schedule
    availabilities = Availability.query.filter_by(tutor_email=tutor_email).all()
    # Fetch the meetings schedule
    meetings = Meetings.query.filter_by(user_email=tutor_email).all()

    # Prepare to calculate available time slots
    # Assume we are only dealing with full hours for simplicity
    weekly_avail = {i: set(range(24)) for i in range(7)}  # 0=Monday, 6=Sunday

    # Remove hours where tutor is busy due to meetings
    for meeting in meetings:
        if meeting.start_time.hour != meeting.end_time.hour:  # Cover cases where meetings last multiple hours
            day_of_week = meeting.meeting_date.weekday()  # Get the weekday as an integer
            hours_in_meeting = range(meeting.start_time.hour, meeting.end_time.hour)
            weekly_avail[day_of_week] -= set(hours_in_meeting)

    # Map the general availability to the actual free times by intersecting with weekly_avail
    for availability in availabilities:
        day_of_week = availability.day_of_week
        hours_in_day = range(availability.start_time.hour, availability.end_time.hour)
        available_hours = set(hours_in_day)
        free_hours = weekly_avail[day_of_week] & available_hours
        if free_hours:  # Only add days with free hours
            returnDict[days[day_of_week]] = list(sorted(free_hours))  # Convert to sorted list for better readability

    return returnDict


@app.route('/viewAvailability', methods=['POST'])
def viewAvailability():
    data = request.get_json()
    tutor_email = data.get("tutorEmail")

    try:
        availabilityDict = availabilityHelper(tutor_email)
        return jsonify(availabilityDict)
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500



if __name__ == '__main__':
    app.run()