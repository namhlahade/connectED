//
//  Review.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import Foundation
import SwiftData

@Observable
class Review: Identifiable, Codable {
    var email: String
    var rating: Double
    var clarity: Double
    var prep: Double
    var review: String
    
    init(email: String, rating: Double, clarity: Double, prep: Double, review: String) {
        self.email = email
        self.rating = rating
        self.clarity = clarity
        self.prep = prep
        self.review = review
    }
}
