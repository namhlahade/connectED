//
//  TutorsResponse.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

struct TutorResponse: Codable {
    let availabilities: [String: [Int]]
    let bio: String
    let email: String
    let image: String?
    let name: String
    let price: Double
    let tutorClasses: [String]

    private enum CodingKeys: String, CodingKey {
        case availabilities, bio, email, image, name, price, tutorClasses = "tutor_classes"
    }
    
    func getInfoTutor() {
        //var ret = Tutor(name: self.name, email: self.email, courses: [], status: .offline, reviews: [], isFavorite: false, availability: [])
        
        // Process image
        
        
        // Process courses
        var allCourses: [Course] = []
        for course in tutorClasses {
            let courseArr = course.components(separatedBy: " ")
            let subject = Tutor.Subject(rawValue: courseArr[0].lowercased())!
            allCourses.append(Course(subject: subject, code: courseArr[1]))
        }
        
        // Process status
        
        
        // Process favorites
        
        // Calculate rating
        
        
        // Process availability
//        for day in Availability.Day.allCases {
//            var day_index = day.rawValue.capitalized(with: nil)
//            for times in self.availabilities[day_index]! {
//                // algorithm that goes through the times and creates availability objects for each
//                //ret.availability.append(Availability(day: <#T##Availability.Day#>, times: <#T##[Date]#>))
//            }
//        }
        //return Tutor(name: name, email: email, bio: bio, courses: allCourses, rating: 0, price: price, status: .offline, reviews: [], isFavorite: false, availability: [])
        
        // Process reviews
        
    }
}

struct TutorsResponse: Codable {
    let tutors: [TutorResponse]
    
    private func getTutors() -> [Tutor] {
        var ret: [Tutor] = []
        for tutor in self.tutors {
            //ret.append(tutor.getTutor())
        }
        return ret
    }
}
