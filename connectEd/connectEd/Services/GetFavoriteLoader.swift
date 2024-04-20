import Foundation

@Observable
class GetFavoriteLoader {
    let apiClient = GetFavoriteAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: FavoritesResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func getFavoritesInfo(email: EmailStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.getFavorites(email: email)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
