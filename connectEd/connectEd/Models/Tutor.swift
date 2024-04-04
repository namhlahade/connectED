//
//  Tutor.swift
//  connectEd
//
//  Created by James Qu on 4/4/24.
//

import Foundation
import SwiftData

@Model
class Tutor: Identifiable {
    var name: String
    var email: String?
    var bio: String?
    var courses: [String]
    var image: URL?
    var status: Status
    var rating: Int?
    
    init(name: String, email: String? = nil, bio: String? = nil, courses: [String], image: URL? = nil, status: Status, rating: Int? = nil) {
        self.name = name
        self.email = email
        self.bio = bio
        self.courses = courses
        self.image = image
        self.status = status
        self.rating = rating
    }
    
}

// Used to show if a tutor is online or offline
enum Status {
    case online
    case offline
}
