//
//  AddAvailabilityInput.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

struct AddAvalabilityInput: Codable {
    let day_of_week: Int
    let start_time: String
    let end_time: String
    let tutor_email: String
}
