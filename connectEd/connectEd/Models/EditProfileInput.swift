import Foundation

struct EditTutorInput: Codable {
    var tutorEmail: String
    var name: String
    var bio: String
    var courses: [String]
    var availability: [AvailabilitySlot]
}

struct AvailabilitySlot: Codable {
    var dayOfWeek: Int
    var startTime: String
    var endTime: String
}
