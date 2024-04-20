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
    var image: String?
    var status: Status // computed in the frontend
    var rating: Double
    var price: Double
    var reviews: [Review]
    var isFavorite: Bool
    var availability: [Availability]
    
    init(id: UUID = UUID(), name: String, email: String, bio: String? = nil, courses: [Course], image: String? = nil, status: Status, rating: Double = 2.0, price: Double = 15.00, reviews: [Review], isFavorite: Bool, availability: [Availability]) {
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
        self.isFavorite = isFavorite
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
        var image: String = ""
        var status: Status = .online
        var price: Double = 0.0
        var availability: [Availability] = []
    }
    
    var dataForForm: FormData {
        FormData(
            id: id,
            name: name,
            email: email,
            bio: bio ?? "",
            courses: courses,
            image: image ?? "",
            status: status,
            price: price ?? 0.0,
            availability: availability
        )
    }
    
    static func create(from formData: FormData) {
        let tutor = Tutor(name: formData.name, email: formData.email, courses: formData.courses, status: formData.status, reviews: [], isFavorite: false, availability: formData.availability)
        Tutor.update(tutor, from: formData)
    }
    
    static func update(_ tutor: Tutor, from formData: FormData) {
        tutor.name = formData.name
        tutor.email = formData.email
        tutor.bio = formData.bio.isEmpty ? nil : formData.bio
        tutor.courses = formData.courses
        tutor.image = formData.image.isEmpty ? nil : formData.image
        tutor.status = formData.status
        tutor.price = formData.price
        tutor.availability = formData.availability
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
        Tutor(name: "James", email: "james@duke.edu", bio: "Random student", courses: [Course(subject: .ece, code: "350")], status: Status.online, rating: 4.0, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], isFavorite: true,  availability: []),
        Tutor(name: "Namh", email: "namh@duke.edu", courses: [Course(subject: .egr, code: "101"), Course(subject: .ece, code: "661")], status: Status.offline, rating: 0.0, reviews: [], isFavorite: false,  availability: []),
        Tutor(name: "Neel", email: "neel@duke.edu", courses: [], status: Status.offline, reviews: [], isFavorite: true,  availability: []),
        Tutor(name: "Namh Lahade", email: "namhlahade@duke.edu", courses: [], status: Status.offline, rating: 1.0, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], isFavorite: false,  availability: [Availability(day: .sunday, times: [dateGetter("00:00"), dateGetter("02:00")]), Availability(day: .friday, times: [dateGetter("14:30"), dateGetter("16:00")])]),
        Tutor(name: "Nick", email: "neel@duke.edu", courses: [], status: Status.online, reviews: [], isFavorite: true,  availability: []),
    ]
}

