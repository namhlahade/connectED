import Foundation

@Observable
class EditProfileLoader {
    let apiClient = EditProfileAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addUserMeeting(editProfileInput: EditTutorInput) async {
        self.state = .loading
        do {
            let response = try await apiClient.editProfile(editProfileInput: editProfileInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
