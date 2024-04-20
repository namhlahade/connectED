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
