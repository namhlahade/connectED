//
//  Tutor.swift
//  connectEd
//
//  Created by James Qu on 4/4/24.
//

import Foundation
import SwiftData

//@Model
class Tutor: Identifiable {
    var name: String
    var email: String
    var bio: String?
    var courses: [String]?
    var image: URL?
    var status: Status
    var rating: Double?
    var price: Double?
    var reviews: [Review]?
    
    init(name: String, email: String, bio: String? = nil, courses: [String]? = nil, image: URL? = nil, status: Status, rating: Double? = nil, price: Double? = nil, reviews: [Review]? = nil) {
        self.name = name
        self.email = email
        self.bio = bio
        self.courses = courses
        self.image = image
        self.status = status
        self.rating = rating
        self.price = price
        self.reviews = reviews
    }
    
}

// Used to show if a tutor is online or offline
enum Status: String, Codable, Identifiable {
    var id: Self { self }
    case online
    case offline
}
