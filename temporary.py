@app.route("/getTutorAndClass", methods=['GET'])
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
                'classes': [tc.className for tc in tutor.tutor_classes]
            }
            tutors_data.append(tutor_info)

        return jsonify({"allTutors": tutors_data})
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
    
    try:
        existing_tutor = User.query.filter_by(email=email).first()
        if existing_tutor:
            return jsonify({"error": "Email already exists"}), 400

        tutor = User(name=name, email=email, bio=bio, rating=rating, isOnline=isOnline, image=image, price=price)
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
        users_data = []
        for user in users:
            user_data = {
                'uid': user.uid,
                'name': user.name,
                'email': user.email,
                'bio': user.bio,
                'rating': user.rating,
                'image': user.image,
            }
            users_data.append(user_data)
        
        return {"users": users_data}
    
    except Exception as e:
        db.session.rollback()
        return str(e), 500

@app.route('/addTutorClass', methods=['POST'])
def addTutorClass():
    data = request.get_json()
    tutorId = data.get('tutorId')
    newClass = data.get('className')
    try:
        user = User.query.filter_by(uid=tutorId).first()

        if not user:
            return jsonify({'error': 'Tutor or Class not found'}), 404

        existing_tutor_class = TutorClass.query.filter_by(uid=tutorId, className=newClass).first()
        if existing_tutor_class:
            return jsonify({'error': 'Tutor class already exists'}), 400

        new_tutor_class = TutorClass(uid=tutorId, className=newClass)

        db.session.add(new_tutor_class)
        db.session.commit()

        return jsonify({'message': 'Tutor class added successfully'}), 201
    
    except Exception as e:
            db.session.rollback()
            return str(e), 500


@app.route('/getTutorClasses', methods=['POST'])
def getTutorClasses():
    data = request.get_json()
    tutorId = data.get('tutorId')

    tutor = User.query.get(tutorId)
    if not tutor:
        return jsonify({'error': 'Tutor not found'}), 404
    tutor_classes = TutorClass.query.filter_by(uid=tutorId).all()
    class_names = [cls.className for cls in tutor_classes]

    return jsonify({'classes': class_names}), 200

@app.route('/deleteTutorClass', methods=['POST'])
def deleteTutorClass():
    data = request.get_json()
    tutorId = data.get('tutorId')
    className = data.get('className')

    if not tutorId:
        return jsonify({'error': 'Missing tutorId'}), 400

    tutorClass = TutorClass.query.filter_by(uid=tutorId, className=className).first()
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

    return jsonify({"tutorAvailability": availability_data}), 200