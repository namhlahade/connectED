import Foundation

class AddAvailabilityAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func addAvailability(availabilityInput: AddAvalabilityInput) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/addAvailability"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(availabilityInput)
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        return response
        

    }
}
