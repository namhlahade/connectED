//
//  ReviewResponse.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

struct ReviewResponse: Codable {
    let reviews: [oneReview]
}

struct oneReview: Codable {
    let clarity: Int
    let prep: Int
    let rating: Int
    let reviewText: String

    enum CodingKeys: String, CodingKey {
        case clarity
        case prep
        case rating
        case reviewText = "review_text"
    }
}
