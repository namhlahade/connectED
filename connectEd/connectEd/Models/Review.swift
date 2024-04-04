//
//  Review.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import Foundation


class Review: Identifiable {
    var author: String
    var date: Date
    var rating: Int
    var description: String
    
    init(author: String, date: Date, rating: Int, description: String) {
        self.author = author
        self.date = date
        self.rating = rating
        self.description = description
    }
}
