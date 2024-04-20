//
//  EmailStruct.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation
import SwiftData

@Model
class Email: Identifiable {
    var id: UUID = UUID()
    var userEmail: String
    
    init(id: UUID, userEmail: String){
        self.id = id
        self.userEmail = userEmail
    }
    

    static func create(email: String, context: ModelContext) {
      let email = Email(id: UUID(), userEmail: email)
      context.insert(email)
    }
    
}

struct EmailStruct: Codable {
    let tutorEmail: String
}
