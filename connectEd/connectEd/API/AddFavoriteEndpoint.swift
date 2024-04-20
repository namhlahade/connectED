//
//  AddFavoriteEndpoint.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

class AddFavoriteTutorAPI: APIClient {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func addFavorite(favoriteInput: FavoriteInputStruct) async throws -> AddAPIResponse {
        let url = "https://shielded-ocean-89788-33c0d45404d1.herokuapp.com/addFavorite"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(favoriteInput)
        let response: AddAPIResponse = try await performPostRequest(url: url, data: jsonData)
        print(response)
        return response
    }
}
