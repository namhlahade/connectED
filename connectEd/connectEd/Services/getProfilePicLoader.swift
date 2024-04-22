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
            print("got past get photo request")
            self.state = .success(data: response)
            print("got past to turn into success: \(self.state)")
        } catch {
            self.state = .failed(error: error)
        }
    }
}
