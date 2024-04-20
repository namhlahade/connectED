//
//  AddFavoriteLoader.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

@Observable
class AddFavoriteLoader {
    let apiClient = AddFavoriteTutorAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addToFavorites(favoriteInput: FavoriteInputStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.addFavorite(favoriteInput: favoriteInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
