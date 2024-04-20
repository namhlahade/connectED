import Foundation

struct ViewAvailabilityResponse: Codable {
    let Monday: [Int]
    let Tuesday: [Int]
    let Wednesday: [Int]
    let Thursday: [Int]
    let Friday: [Int]
    let Saturday: [Int]
    let Sunday: [Int]
}
