//
//  TutorReviewInputStruct.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

struct TutorReviewInputStruct: Codable {
    let rating: Int
    let clarity: Int
    let prep: Int
    let review: String
    let tutorEmail: String
}
