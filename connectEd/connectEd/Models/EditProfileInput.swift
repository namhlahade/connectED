import Foundation

struct EditTutorInput: Codable {
    var tutorEmail: String
    var image: Data?
    var name: String
    var bio: String
    var courses: [String]
    var price: Double
    var availability: [AvailabilityObject]
    
    enum CodingKeys: String, CodingKey {
        case tutorEmail, image, name, bio, courses, price, availability
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tutorEmail, forKey: .tutorEmail)
        try container.encode(name, forKey: .name)
        try container.encode(bio, forKey: .bio)
        try container.encode(courses, forKey: .courses)
        try container.encode(price, forKey: .price)
        try container.encode(availability, forKey: .availability)
        if let imageData = image {
            let base64String = imageData.base64EncodedString()
            try container.encode(base64String, forKey: .image)
        }
    }
}
