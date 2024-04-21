//
//  TutorsResponse.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

struct TutorInfo: Codable {
    let availabilities: [String: [Int]]
    let bio: String?
    let email: String
    let favorites: [String]
    let image: String
    let name: String
    let price: Double
    let reviews: [Rev]
    let tutorClasses: [String]

    enum CodingKeys: String, CodingKey {
        case availabilities, bio, email, favorites, image, name, price, reviews
        case tutorClasses = "tutor_classes"
    }
    
    func getInfoTutor(userEmail: String) -> Tutor {
        var allCourses: [Course] = []
        for course in tutorClasses {
            let courseArr = course.components(separatedBy: " ")
            print(courseArr[0])
            let subject = Tutor.Subject(rawValue: courseArr[0].lowercased())!
            print(subject)
            print(courseArr[1])
            allCourses.append(Course(subject: subject, code: courseArr[1]))
        }
        var allReviews: [Review] = []
        for newReview in reviews {
            allReviews.append(Review(email: email, rating: Double(newReview.rating), clarity: Double(newReview.clarity), prep: Double(newReview.prep), review: newReview.review))
        }
        let availability: [Availability] = convertAvailability(dictionary: availabilities)
        
        let status: Status = isPersonAvailable(availability: availability)
        
        var totalRating: Double = 0
        var numReviews: Double = 0
        
        for review in reviews {
            totalRating += Double(review.rating)
            numReviews += 1
        }
        
        let avgRatings: Double = totalRating/numReviews
        
        if numReviews > 0 {
            return Tutor(name: name, email: email, bio: bio, courses: allCourses, image: image, status: status, rating: avgRatings, price: price, reviews: allReviews, favorites: favorites, availability: availability)
        }
        else{
            return Tutor(name: name, email: email, bio: bio, courses: allCourses, image: image, status: status, price: price, reviews: allReviews, favorites: favorites, availability: availability)
        }

    }
        
}

struct Rev: Codable {
    let clarity: Int
    let prep: Int
    let rating: Int
    let review: String
}

struct TutorClass: Codable {
    let className: String

    enum CodingKeys: String, CodingKey {
        case className = "class_name"
    }
}

struct TutorsResponse: Codable {
    let tutors: [TutorInfo]
    
    func getTutors() -> [Tutor] {
        var ret: [Tutor] = []
        for tutor in self.tutors {
            ret.append(tutor.getInfoTutor(userEmail: tutor.email))
        }
        return ret
    }
}

func convertAvailability(dictionary: [String: [Int]]) -> [Availability] {
    var availabilities: [Availability] = []
    
    let calendar = Calendar.current
    let referenceDateComponents = DateComponents(year: 2000, month: 1, day: 1)
    guard let referenceDate = calendar.date(from: referenceDateComponents) else { return [] }
    
    for (dayString, hours) in dictionary {
        guard let day = Availability.Day(rawValue: dayString.lowercased()) else {
            print("Invalid day string: \(dayString)")
            continue
        }
        
        let sortedHours = hours.sorted()
        var currentStartIndex = 0
        if !sortedHours.isEmpty {
            for i in 0..<sortedHours.count - 1 {
                if sortedHours[i] + 1 != sortedHours[i + 1] {
                    if let startDate = calendar.date(bySettingHour: sortedHours[currentStartIndex], minute: 0, second: 0, of: referenceDate),
                       let endDate = calendar.date(bySettingHour: sortedHours[i] + 1, minute: 0, second: 0, of: referenceDate) {
                        var newTimes: [Date] = []
                        newTimes.append(startDate)
                        newTimes.append(endDate)
                        let availability = Availability(day: day, times: newTimes)
                        availabilities.append(availability)
                    }
                    currentStartIndex = i + 1
                }
            }
            if let startDate = calendar.date(bySettingHour: sortedHours[currentStartIndex], minute: 0, second: 0, of: referenceDate),
               let endDate = calendar.date(bySettingHour: sortedHours.last! + 1, minute: 0, second: 0, of: referenceDate) {
                var newTimes: [Date] = []
                newTimes.append(startDate)
                newTimes.append(endDate)
                let availability = Availability(day: day, times: newTimes)
                availabilities.append(availability)
            }
        }
    }
    
    return availabilities
}

func isPersonAvailable(availability: [Availability]) -> Status {
    
    let now = Date()
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = "HH:mm"
    let current_time = dateGetter(formatter.string(from: now))
    var current_weekday: Int = calendar.component(.weekday, from: now)
    
    if current_weekday == 1 {
        current_weekday = 6
    }
    else {
        current_weekday -= 2
    }
    
    for availability in availability {
        /*print(Availability.Day.allCases)
        print(Availability.Day.allCases[current_weekday - 1])
        print(availability.day)
        print(Availability.Day.allCases[current_weekday - 1] == availability.day)*/
        print("Current day: \(current_weekday) \(Availability.Day.allCases[current_weekday]), Comparison day: \(availability.day)")
        if (Availability.Day.allCases[current_weekday] == availability.day) {
            if (current_time >= availability.times[0] && current_time <= availability.times[1]) {
                //print("current: \(formatter.string(from: current_time)), \(formatter.string(from: availability.times[0])) - \(formatter.string(from: availability.times[1])) = online")
                return .online
            }
        }
    }
    return .offline
    
}
