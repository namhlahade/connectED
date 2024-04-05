//
//  Review.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import Foundation
import SwiftData


class Review: Identifiable {
    var author: String
    var date: Date
    var rating: Int
    var body: String
    
    init(author: String, date: Date, rating: Int, body: String) {
        self.author = author
        self.date = date
        self.rating = rating
        self.body = body
    }
}
