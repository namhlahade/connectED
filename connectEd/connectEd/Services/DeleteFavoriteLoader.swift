import Foundation

@Observable
class DeleteFavoriteLoader {
    let apiClient = DeleteFavoriteAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addTutorInfo(favoriteInput: FavoriteInputStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.deleteFavorite(favoriteInput: favoriteInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
