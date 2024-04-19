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
}

struct TutorsResponse: Codable {
    let tutors: [TutorsResponse]
}
