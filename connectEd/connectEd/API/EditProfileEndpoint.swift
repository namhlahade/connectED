import Foundation

class EditProfileAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func editProfile(editProfileInput: EditTutorInput) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/editProfile"
        print(editProfileInput)
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(editProfileInput)
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        print(response)
        return response
    }
}
