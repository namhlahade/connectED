import Foundation

class DeleteFavoriteAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func deleteFavorite(favoriteInput: FavoriteInputStruct) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/deleteFavorite"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(favoriteInput)
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        return response
    }
}
