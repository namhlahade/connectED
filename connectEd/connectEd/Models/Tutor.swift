//
//  Tutor.swift
//  connectEd
//
//  Created by James Qu on 4/4/24.
//

import Foundation
import SwiftData

// Make Tutor Object Codable
@Observable
class Tutor: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var bio: String?
    var courses: [Course]
    var image: Data?
    var status: Status // computed in the frontend
    var rating: Double // computed in the frontend
    var price: Double
    var reviews: [Review]
    var favorites: [String]
    var availability: [Availability]
    

    init(id: UUID = UUID(), name: String, email: String, bio: String? = nil, courses: [Course], image: Data? = nil, status: Status, rating: Double = 0.0, price: Double = 0.0, reviews: [Review], favorites: [String], availability: [Availability]) {
        self.id = id
        self.name = name
        self.email = email
        self.bio = bio
        self.courses = courses
        self.image = image
        self.status = status
        self.rating = rating
        self.price = price
        self.reviews = reviews
        self.favorites = favorites
        self.availability = availability
    }
    
}

// Used to show if a tutor is online or offline
enum Status: String, Codable, Identifiable {
    var id: Self { self }
    case online
    case offline
}

extension Tutor {
    struct FormData: Identifiable {
        var id: UUID = UUID()
        var name: String = ""
        var email: String = ""
        var bio: String = ""
        var courses: [Course] = []
        var image: Data = Data()
        var price: Double = 0.0
        var availability: [Availability] = []
        var selectedHours: [[Int]] = []
        var areAM: [[Bool]] = []
    }
    
    var dataForForm: FormData {
        FormData(
            id: id,
            name: name,
            email: email,
            bio: bio ?? "",
            courses: courses,
            image: image ?? Data(),
            price: price,
            availability: availability,
            selectedHours: Tutor.getSelectedHours(availability: availability),
            areAM: Tutor.getAreAM(availability: availability)
        )
    }
    
    static func getSelectedHours(availability: [Availability]) -> [[Int]] {
        var ret: [[Int]] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        
        for avail in availability {
            ret.append([Int(formatter.string(from: avail.times[0]))!, Int(formatter.string(from: avail.times[1]))!])
        }
        
        return ret
    }
    
    static func getAreAM(availability: [Availability]) -> [[Bool]] {
        var ret: [[Bool]] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        
        for avail in availability {
            ret.append([formatter.string(from: avail.times[0]) == "AM" ? true : false, formatter.string(from: avail.times[1]) == "AM" ? true : false])
        }
        
        return ret
    }
    
    static func getAvailability(existingAvailability: [Availability], selectedHours: [[Int]], areAM: [[Bool]]) -> [Availability] {
        var ret: [Availability] = []
        
        for (index, _) in existingAvailability.enumerated() {
            ret.append(Availability(day: existingAvailability[index].day, times: [editTime(selectedHour: selectedHours[index][0], isAM: areAM[index][0]), editTime(selectedHour: selectedHours[index][1], isAM: areAM[index][1])]))
        }
        
        return ret
    }
    
    static func create(from formData: FormData) {
        let avail: [Availability] = getAvailability(existingAvailability: formData.availability, selectedHours: formData.selectedHours, areAM: formData.areAM)
        let tutor = Tutor(name: formData.name, email: formData.email, courses: formData.courses, status: .online, price: formData.price, reviews: [], favorites: [], availability: avail)
        Tutor.update(tutor, from: formData)
    }
    
    static func update(_ tutor: Tutor, from formData: FormData) {
        tutor.name = formData.name
        tutor.email = formData.email
        tutor.bio = formData.bio.isEmpty ? nil : formData.bio
        tutor.courses = formData.courses
        tutor.image = formData.image
        tutor.price = formData.price
        print("Current Price: \(tutor.price)")
        tutor.availability = getAvailability(existingAvailability: formData.availability, selectedHours: formData.selectedHours, areAM: formData.areAM)
    }
}

extension Tutor {
    enum Subject: String, Codable, CaseIterable, Identifiable {
        var id: Self { self }
        case ece
        case cs
        case egr
        case phys
        case chem
    }
}

extension Tutor {
    static let previewData: [Tutor] = [
        Tutor(name: "Neel Runton", email: "nrunton@gmail.com", bio: "Random student", courses: [Course(subject: .ece, code: "350")], status: Status.online, rating: 4.0, price: 20.00, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], favorites: ["namh@duke.edu", "neel@duke.edu", "nick@duke.edu"],  availability: []),
        Tutor(name: "James", email: "james@duke.edu", bio: "Random student", courses: [Course(subject: .ece, code: "350")], status: Status.online, rating: 4.0, price: 20.00, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], favorites: ["namh@duke.edu", "neel@duke.edu", "nick@duke.edu"],  availability: []),
        Tutor(name: "Namh", email: "namh@duke.edu", courses: [Course(subject: .egr, code: "101"), Course(subject: .ece, code: "661")], status: Status.offline, rating: 0.0, price: 5.00, reviews: [], favorites: ["neel@duke.edu"],  availability: []),
        Tutor(name: "Neel", email: "neel@duke.edu", courses: [], status: Status.offline, price: 12.0, reviews: [], favorites: ["namhlahade@duke.edu"],  availability: []),
        Tutor(name: "Namh Lahade", email: "namhlahade@duke.edu", courses: [], status: Status.offline, rating: 1.0, price: 40.00, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], favorites: ["neel@duke.edu"],  availability: [Availability(day: .sunday, times: [dateGetter("00:00"), dateGetter("02:00")]), Availability(day: .friday, times: [dateGetter("14:30"), dateGetter("16:00")])])
    ]
}

