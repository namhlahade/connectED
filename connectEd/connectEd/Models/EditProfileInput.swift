import Foundation

struct EditTutorInput: Codable {
    var tutorEmail: String
    var name: String
    var bio: String
    var courses: [String]
    var price: Double
    var availability: [AvailabilityObject]
}
