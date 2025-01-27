//
//  Availability.swift
//  connectEd
//
//  Created by Neel Runton on 4/19/24.
//

import Foundation

@Observable
class Availability: Identifiable, Codable {
    var id = UUID()
    var day: Day
    var times: [Date]
    
    init(id: UUID = UUID(), day: Day, times: [Date]) {
        self.id = id
        self.day = day
        self.times = times
    }
    
    
}

extension Availability {
    enum Day: String, Codable, CaseIterable, Identifiable {
        var id: Self { self }
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
}
