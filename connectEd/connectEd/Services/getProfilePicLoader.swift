import Foundation
import SwiftUI

class getProfilePicLoader {
    let apiClient = FetchProfilePicEndpoint()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: UIImage?)
        case failed(error: Error)
    }
    
    @MainActor
    func getProfilePic(path: String) async {
        print("Got to getProfilePic")
        self.state = .loading
        do {
            print("Got past do")
            let response = try await apiClient.getThePhoto(path: path)
            print(response)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
