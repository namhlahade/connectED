import Foundation

struct EditTutorInput: Codable {
    var tutorEmail: String
    var image: String
    var name: String
    var bio: String
    var courses: [String]
    var price: Double
    var availability: [AvailabilityObject]
    
    enum CodingKeys: String, CodingKey {
        case tutorEmail, image, name, bio, courses, price, availability
    }
}
