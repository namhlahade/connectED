import UIKit

class Availability: Identifiable, Codable {
    var id = UUID()
    var day: Day
    var times: [Date]
    
    init(id: UUID = UUID(), day: Day, times: [Date]) {
        self.id = id
        self.day = day
        self.times = times
    }
    
    var description: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timesString = times.map { timeFormatter.string(from: $0) }.joined(separator: " to ")
        return "\(day.rawValue): [\(timesString)]"
    }
    
}

extension Availability {
    enum Day: String, Codable, CaseIterable, Identifiable {
        var id: Self { self }
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
}

func convertAvailability(dictionary: [String: [Int]]) -> [Availability] {
    var availabilities: [Availability] = []
    
    var calendar = Calendar.current
    let referenceDateComponents = DateComponents(year: 2023, month: 1, day: 1)
    guard let referenceDate = calendar.date(from: referenceDateComponents) else { return [] }
    
    for (dayString, hours) in dictionary {
        guard let day = Availability.Day(rawValue: dayString) else {
            print("Invalid day string: \(dayString)")
            continue
        }
        
        let sortedHours = hours.sorted()
        var currentStartIndex = 0
        if !sortedHours.isEmpty {
            for i in 0..<sortedHours.count - 1 {
                if sortedHours[i] + 1 != sortedHours[i + 1] {
                    // End of a contiguous block found
                    if let startDate = calendar.date(bySettingHour: sortedHours[currentStartIndex], minute: 0, second: 0, of: referenceDate),
                       let endDate = calendar.date(bySettingHour: sortedHours[i] + 1, minute: 0, second: 0, of: referenceDate) {
                        var newTimes: [Date] = []
                        newTimes.append(startDate)
                        newTimes.append(endDate)
                        let availability = Availability(day: day, times: newTimes)
                        availabilities.append(availability)
                    }
                    currentStartIndex = i + 1
                }
            }
            // Handle the last block
            if let startDate = calendar.date(bySettingHour: sortedHours[currentStartIndex], minute: 0, second: 0, of: referenceDate),
               let endDate = calendar.date(bySettingHour: sortedHours.last! + 1, minute: 0, second: 0, of: referenceDate) {
                var newTimes: [Date] = []
                newTimes.append(startDate)
                newTimes.append(endDate)
                let availability = Availability(day: day, times:newTimes)
                availabilities.append(availability)
            }
        }
    }
    
    return availabilities
}

let availabilities: [String: [Int]] = [
    "Monday": [9, 10, 11, 14, 15],
    "Tuesday": [10, 11, 12, 13, 16, 17],
    "Wednesday": [],
    "Thursday": [13, 14, 15],
    "Friday": [9, 11, 15, 16],
    "Saturday": [10, 12],
    "Sunday": []
]

let convertedAvailabilities = convertAvailability(dictionary: availabilities)
convertedAvailabilities.forEach { print($0) }


