//
//  Tutor.swift
//  connectEd
//
//  Created by James Qu on 4/4/24.
//

import Foundation
import SwiftData

@Observable
class Tutor: Identifiable {
    var id = UUID()
    var name: String
    var email: String
    var bio: String?
    var courses: [Course]
    var image: String?
    var status: Status
    var rating: Double?
    var price: Double?
    var reviews: [Review]?
    var isFavorite: Bool
    var availability: [String: [Date]]
    
    init(id: UUID = UUID(), name: String, email: String, bio: String? = nil, courses: [Course], image: String? = nil, status: Status, rating: Double? = nil, price: Double? = nil, reviews: [Review]? = nil, isFavorite: Bool, availability: [String : [Date]] = [:]) {
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
        if availability == [:] {
            let days: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            /*
             formatter.dateFormat = "yyyy/MM/dd HH:mm
             let someDateTime = formatter.date(from: "2016/10/08 22:31")
             */
            for day in days {
                self.availability = [day: [formatter.date(from: "00:00")!, formatter.date(from: "00:00")!]]
            }
        }
        
        
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
        var availability: [String: [Date]] = ["Sunday": [], "Monday": [], "Tuesday": [], "Wednesday": [], "Thursday": [], "Friday": [], "Saturday": []]
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
            availability: [:]
        )
    }
    
    static func create(from formData: FormData, context: ModelContext) {
        let tutor = Tutor(name: formData.name, email: formData.email, courses: formData.courses, status: formData.status, isFavorite: false)
        Tutor.update(tutor, from: formData)
        //context.insert(tutor)
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
        Tutor(name: "James", email: "james@duke.edu", bio: "Random student", courses: [], status: Status.online, isFavorite: true, availability: [:]),
        Tutor(name: "Namh", email: "namh@duke.edu", courses: [], status: Status.offline, isFavorite: false, availability: [:])
    ]
}

