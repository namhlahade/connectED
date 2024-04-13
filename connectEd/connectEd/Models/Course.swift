//
//  Course.swift
//  connectEd
//
//  Created by Neel Runton on 4/12/24.
//

import Foundation
import SwiftData


@Observable
class Course: Identifiable {
    var id = UUID()
    var subject: Tutor.Subject
    var code: String
    
    init(id: UUID = UUID(), subject: Tutor.Subject, code: String) {
        self.id = id
        self.subject = subject
        self.code = code
    }
}
