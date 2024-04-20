import Foundation

struct ViewAvailabilityResponse: Codable {
    let Monday: [Int]
    let Tuesday: [Int]
    let Wednesday: [Int]
    let Thursday: [Int]
    let Friday: [Int]
    let Saturday: [Int]
    let Sunday: [Int]
    
    func hoursFor(dayOfWeek: Int) -> [Int] {
        switch dayOfWeek {
        case 1: return Sunday
        case 2: return Monday
        case 3: return Tuesday
        case 4: return Wednesday
        case 5: return Thursday
        case 6: return Friday
        case 7: return Saturday
        default: return []
        }
    }
}

func isPersonAvailable(availability: ViewAvailabilityResponse) -> Bool {
    let now = Date()
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: now)
    let weekday = calendar.component(.weekday, from: now)
    
    let availableHoursToday = availability.hoursFor(dayOfWeek: weekday)
    return availableHoursToday.contains(hour)
}
