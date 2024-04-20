//
//  AddMeetingInput.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

struct AddMeetingInput: Codable {
    let user_email: String
    let meeting_date: String
    let start_time: String
    let end_time: String
}
