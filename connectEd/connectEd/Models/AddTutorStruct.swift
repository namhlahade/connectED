import Foundation

struct AddTutorStruct: Codable {
    var name: String
    var email: String
    var bio: String
    var price: Double
    //var image: Data?
    var courses: [String]
    var availability: [AvailabilityObject]
}

struct AvailabilityObject: Codable {
    var day_of_week: Int
    var start_time: String
    var end_time: String
}
