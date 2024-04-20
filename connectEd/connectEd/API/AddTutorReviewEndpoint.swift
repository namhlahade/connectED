import Foundation

class AddTutorReviewAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func addTutorReview(tutorReviewInput: TutorReviewInputStruct) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/addTutorReview"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(tutorReviewInput)
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        return response
    }
}
