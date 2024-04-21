import Foundation

class AddMeetingAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func addMeeting(addMeetingInput: AddMeetingInput) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/addMeeting"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(addMeetingInput)
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        return response
    }
}
