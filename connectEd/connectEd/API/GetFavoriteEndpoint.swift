import Foundation

class GetFavoriteAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getFavorites(email: EmailStruct) async throws -> FavoritesResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/getFavorite"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(email)
        let response: FavoritesResponse = try await performPostRequest(url: url, data: jsonData)
        return response
        

    }
}
